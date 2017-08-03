/**
* @author FABIO ELIA LOCATELLI
* @studentID 2143701
* @revisionDate 11/10/2016
* @purpose CREATE PROCEDURES COLLECTION
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

USE `EnRoute`;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `createAccount`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	createAccount
* INPUT PARAMETERS 	: 	GOOGLE UNIQUE IDENTIFIER, ACCOUNT EMAIL ADDRESS, ACCOUNT FIRST NAME, ACCOUNT LAST NAME
* OUTPUT PARAMETER 	: 	THE NUMBER OF ROWS RETURNED
*/
CREATE PROCEDURE `createAccount`(IN paramGoogleID VARCHAR(45), IN paramEmailAddress VARCHAR(45), IN paramFirstName VARCHAR(45), IN paramLastName VARCHAR(45), OUT resAffectedRows INT)
SQL SECURITY INVOKER
BEGIN

	/*PERFORM BASIC DATA SANITISING ON DATABASE SIDE*/
	SET @safeGoogleID := UTILSANITISER(paramGoogleID, '@', '?', ' ', '');
	SET @travellerID := CONCAT('TRAVELLER', '_', @safeGoogleID);
	
    START TRANSACTION;
		/*VERIFY THAT THE GOOGLE UNIQUE IDENTIFIER DOES NOT ALREADY EXIST IN THE USER TABLE*/
		IF NOT EXISTS (SELECT `userID` FROM `User` WHERE `userID` LIKE @safeGoogleID)
		THEN
			/*CREATES AN ACCOUNT DEPENDING ON THE GOOGLE UNIQUE IDENTIFIER*/
			INSERT INTO `User`(`userID`,`emailAddress`,`firstName`,`lastName`) VALUES (@safeGoogleID, paramEmailAddress, paramFirstName, paramLastName);
			INSERT INTO `Traveller`(`travellerID`,`userID`) VALUES (@travellerID, @safeGoogleID);
		END IF;
		/*RETURNS THE NUMBER OF ROWS AFFECTED BY THE LAST STATEMENT, NOT BY THE WHOLE PROCEDURE*/
		SET resAffectedRows := ROW_COUNT();
	COMMIT;
    
END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `createTrip`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	createTrip
* INPUT PARAMETERS 	: 	GOOGLE UNIQUE IDENTIFIER, TRIP NAME, TRIP START DATE, TRIP FINISH DATE
* OUTPUT PARAMETER 	: 	THE NUMBER OF ROWS RETURNED
*/
CREATE PROCEDURE `createTrip`(IN paramGoogleID VARCHAR(45), IN paramTripName VARCHAR(150), IN paramStartDate DATE, IN paramFinishDate DATE, OUT resAffectedRows INT)
SQL SECURITY INVOKER
BEGIN

	/*PERFORM BASIC DATA SANITISING ON DATABASE SIDE*/
	SET @safeGoogleID := UTILSANITISER(paramGoogleID, '@', '?', ' ', '');

	/*GENERATE TRIP IDENTIFIER, BASED ON TRAVELLER ID, AMOUNT OF TRIPS ASSOCIATED WITH THAT ACCOUNT AND TIMESTAMP*/
	SET @travellerID := (SELECT `TravellerID` FROM `Traveller` WHERE `userID` LIKE @safeGoogleID);
	SET @tripCount := (SELECT COUNT(`tripID`) FROM `Trip`);
	SET @formattedTimestamp := UTILTIMESTAMP(10);
	SET @tripID := CONCAT(@travellerID, '_', @tripCount, '_', @formattedTimestamp);

	START TRANSACTION;
		/*VERIFY THAT A TRIP WITH THE SAME NAME IS NOT ASSOCIATED WITH THAT ACCOUNT*/
		IF NOT EXISTS (SELECT `tripName` FROM `Trip` WHERE `tripName` LIKE paramTripName AND `travellerID` LIKE @travellerID)
		THEN
			/*CREATE A TRIP WITH THE GENERATED PRIMARY KEY AND THE INPUT PARAMETERS*/
			INSERT INTO Trip(`tripName`,`startDate`,`finishDate`,`tripID`,`travellerID`) VALUES (paramTripName, paramStartDate, paramFinishDate, @tripID, @travellerID);
		END IF;
		/*RETURNS THE NUMBER OF ROWS AFFECTED BY THE LAST STATEMENT, NOT BY THE WHOLE PROCEDURE*/
		SET resAffectedRows := ROW_COUNT();
	COMMIT;
    
END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `createItinerary`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	createItinerary
* INPUT PARAMETERS 	: 	TRIP UNIQUE IDENTIFIER, ITINERARY NAME, ITINERARY START DATE, ITINERARY FINISH DATE
* OUTPUT PARAMETER 	: 	THE NUMBER OF ROWS RETURNED
*/
CREATE PROCEDURE `createItinerary`(IN paramTripID VARCHAR(45), IN paramItineraryName VARCHAR(150), IN paramStartDate DATE, IN paramFinishDate DATE, OUT resAffectedRows INT)
SQL SECURITY INVOKER
BEGIN

	/*PRIMARY KEY GENERATION FOR ITINERARY*/
	SET @itineraryCount := (SELECT COUNT(`itineraryID`) FROM `Itinerary`);
	SET @formattedTimestamp := UTILTIMESTAMP(10);
	SET @itineraryID := CONCAT(paramTripID, '_', @itineraryCount, '_', @formattedTimestamp);

	/*PRIMARY KEY GENERATION FOR CHECK IN LIST*/
	SET @checkInCount := (SELECT COUNT(`listID`) FROM `CheckIn`);
	SET @checkInID := CONCAT(@itineraryID, '_', @checkInCount, '_', @formattedTimestamp);
    
    /*PRIMARY KEY GENERATION FOR RECOMMENDATION LIST*/
	SET @recommendationCount := (SELECT COUNT(`listID`) FROM `CheckIn`);
	SET @recommendationID := CONCAT(@itineraryID, '_', @recommendationCount, '_', @formattedTimestamp);
    
    /*VERSION NUMBER FOR RECOMMENDATION POLYLINE*/
    SET @recommendationVersion := (SELECT COUNT(`listID`) FROM `Recommendation` WHERE `itineraryID` LIKE @itineraryID);

	START TRANSACTION;
		/*VERIFY THAT AN ITINERARY WITH THE SAME NAME IS NOT ASSOCIATED WITH THE CURRENT TRIP*/
		IF NOT EXISTS (SELECT `itineraryName` FROM `Itinerary` WHERE `tripID` LIKE paramTripID AND `itineraryName` LIKE paramItineraryName)
		THEN
			/*CREATE AN ITINERARY WITH THE GENERATED PRIMARY KEY AND THE INPUT PARAMETERS*/		
			INSERT INTO `Itinerary`(`itineraryID`,`itineraryName`,`startDate`, `finishDate`, `tripID`) VALUES (@itineraryID, paramItineraryName, paramStartDate, paramFinishDate, paramTripID);
			/*ASSOCIATE CHECK-IN RECORD*/
            INSERT INTO `CheckIn`(`listID`,`itineraryID`) VALUES (@checkInID, @itineraryID);
            /*ASSOCIATE RECOMMENDATION RECORD*/
			INSERT INTO `Recommendation`(`listID`,`version`,`itineraryID`) VALUES (@checkInID, @recommendationVersion, @itineraryID);
		END IF;
		/*RETURNS THE NUMBER OF ROWS AFFECTED BY THE LAST STATEMENT, NOT BY THE WHOLE PROCEDURE*/
		SET resAffectedRows := ROW_COUNT();
	COMMIT;
    
END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `addFollower`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	addFollower
* INPUT PARAMETERS 	: 	GOOGLE UNIQUE IDENTIFIER, FOLLOWER EMAIL ADDRESS, TRIP IDENTIFIER
* OUTPUT PARAMETER	:	RETURNED ROWS
*/
CREATE PROCEDURE `addFollower`(IN paramGoogleID VARCHAR(45), IN paramEmailAddress VARCHAR(45), IN paramTripID VARCHAR(45), OUT resAffectedRows INT)
SQL SECURITY INVOKER
BEGIN

	/*PERFORM BASIC DATA SANITISING ON DATABASE SIDE*/
	SET @safeGoogleID := UTILSANITISER(paramGoogleID, '@', '?', ' ', '');
	SET @safeTripID := UTILSANITISER(paramTripID, '@', '?', ' ', '');

	/*RETRIEVE TRAVELLER AND USER IDENTIFIER DEPENDING ON CURRENT TRIP AND GOOGLE IDENTIFIER*/
	SET @tripName := (SELECT `tripName` FROM `queryTravellerUserTrip` WHERE `tripID` LIKE @safeTripID AND `userID` LIKE @safeGoogleID);
	SET @travellerID := (SELECT `travellerID` FROM `queryTravellerUserTrip` WHERE `tripID` LIKE @safeTripID AND `userID` LIKE @safeGoogleID);
    SET @userID := (SELECT `userID` FROM `queryTravellerUserTrip` WHERE `tripID` LIKE @safeTripID AND `userID` LIKE @safeGoogleID);
	SET @travellerFirstName := (SELECT `firstName` FROM `queryTravellerUserTrip` WHERE `tripID` LIKE @safeTripID AND `userID` LIKE @safeGoogleID);
    SET @travellerLastName := (SELECT `lastName` FROM `queryTravellerUserTrip` WHERE `tripID` LIKE @safeTripID AND `userID` LIKE @safeGoogleID);

	/*GENERATE FOLLOWER IDENTIFIER, BASED ON USER IDENTIFIER, AMOUNT OF FOLLOWERS AND TIMESTAMP */
	SET @formattedTimestamp := UTILTIMESTAMP(10);
	SET @followerCount := (SELECT COUNT(`followerID`) FROM `Follower`);
	SET @followerID := CONCAT('FOLLOWING', '_', @userID, @followerCount, '_@_', @formattedTimestamp);

	START TRANSACTION;
		/*VERIFY THAT THE FOLLOWER IS NOT ALREADY ASSOCIATED WITH A SPECIFIC TRIP*/
		IF NOT EXISTS(SELECT `emailAddress` FROM `Follower` WHERE `tripID` LIKE @safeTripID AND `emailAddress` LIKE paramEmailAddress)
		THEN
			INSERT INTO `Follower`(`followerID`,`userID`,`tripID`,`travellerID`,`tripName`,`travellerFirstName`,`travellerLastName`,`emailAddress`) VALUES (@followerID, @safeGoogleID, @safeTripID, @travellerID, @tripName, @travellerFirstName, @travellerLastName, paramEmailAddress);
		END IF;
		/*RETURNS THE NUMBER OF ROWS AFFECTED BY THE LAST STATEMENT, NOT BY THE WHOLE PROCEDURE*/
		SET resAffectedRows := ROW_COUNT();
	COMMIT;
    
END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
