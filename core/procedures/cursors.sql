/**
* @author FABIO ELIA LOCATELLI
* @studentID 2143701
* @revisionDate 11/10/2016
* @purpose CURSOR PROCEDURES COLLECTION
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

USE `EnRoute`;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `listTrips`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	listTrips
* INPUT PARAMETER 	: 	GOOGLE UNIQUE IDENTIFIER
* OUTPUT PARAMETERS	:	TRIP NAMES, TRIP ITINERARIES NUMBER, TRIP START DATES, TRIP FINISH DATES, TRIP NUMBER
*/
CREATE PROCEDURE `listTrips`(IN paramGoogleID VARCHAR(45), OUT resTripNames LONGTEXT, OUT resItinerariesNumber LONGTEXT, OUT resStartDates LONGTEXT, OUT resFinishDates LONGTEXT, OUT resTripsNumber INT)
SQL SECURITY INVOKER
BEGIN
	
    /*PERFORM BASIC DATA SANITISING ON DATABASE SIDE*/
	DECLARE safeGoogleID VARCHAR(45) DEFAULT UTILSANITISER(paramGoogleID, '@', '?', ' ', '');
    
	DECLARE tripCount INT;
	DECLARE fetchedTripName VARCHAR(150);
	DECLARE fetchedStartDate DATE;
	DECLARE fetchedFinishDate DATE;
	DECLARE fetchedTravellerID VARCHAR(45);
	DECLARE userIdentifier VARCHAR(45);

	/*CURSOR AND ITS HANDLER*/
	DECLARE cursorHasFinished INT DEFAULT FALSE;
	DECLARE tripRow CURSOR FOR SELECT `tripName`,`startDate`,`finishDate`,`travellerID` FROM `cursorTrip`;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET cursorHasFinished := TRUE;

	/*TEMPORARY TABLE USED TO STORE RESULTS*/
	DROP TABLE IF EXISTS `cursorTable`;
	CREATE TEMPORARY TABLE IF NOT EXISTS `cursorTable`(`tripName` VARCHAR(150), `startDate` DATE, `finishDate` DATE, `travellerID` VARCHAR(45), `itinerariesCount` VARCHAR(5));

	/*CURSOR OPENING, RETRIEVAL LOOP AND CURSOR CLOSING*/    
	OPEN tripRow;

	TRIPLOOP: LOOP
		FETCH tripRow INTO fetchedTripName, fetchedStartDate, fetchedFinishDate, fetchedTravellerID;
		IF cursorHasFinished
		THEN
		  LEAVE TRIPLOOP;
		END IF;
		
		BEGIN
		
			DECLARE fetchedCount INT;
			
			/*NESTED CURSOR AND ITS HANDLER*/
			DECLARE cursorHasFinished INT DEFAULT FALSE;
			DECLARE itineraryCount CURSOR FOR SELECT COUNT(`itineraryID`) FROM `cursorTripItineraryTraveller` WHERE `userID` LIKE safeGoogleID AND `tripID` LIKE RETURNTRIPIDENTIFIER(safeGoogleID, fetchedTripName);
			DECLARE CONTINUE HANDLER FOR NOT FOUND SET cursorHasFinished := TRUE;
			
			/*NESTED CURSOR OPENING, RETRIEVAL LOOP AND CURSOR CLOSING*/  
			OPEN itineraryCount;
			
			COUNTLOOP: LOOP
				FETCH itineraryCount INTO fetchedCount;
				IF cursorHasFinished
				THEN
				  LEAVE COUNTLOOP;
				END IF;
				INSERT INTO `cursorTable`(`tripName`,`startDate`,`finishDate`,`travellerID`,`itinerariesCount`) VALUES (fetchedTripName, fetchedStartDate, fetchedFinishDate, fetchedTravellerID, fetchedCount);
			END LOOP;
			
			CLOSE itineraryCount;
			
		END;
		
	  END LOOP;
	  
	CLOSE tripRow;

	/*ASSIGN RESULTS TO OUTPUT PARAMETERS*/
	SET userIdentifier := (SELECT `travellerID` FROM `Traveller` WHERE `userID` LIKE safeGoogleID);
	SET resTripsNumber := (SELECT COUNT(`tripName`) FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
	SET resItinerariesNumber := (SELECT GROUP_CONCAT(`itinerariesCount` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
	SET resTripNames := (SELECT GROUP_CONCAT(`tripName` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
	SET resStartDates := (SELECT GROUP_CONCAT(`startDate` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
	SET resFinishDates := (SELECT GROUP_CONCAT(`finishDate` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);

END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `listItineraries`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	listItineraries
* INPUT PARAMETERS 	: 	GOOGLE UNIQUE IDENTIFIER, TRIP IDENTIFIER
* OUTPUT PARAMETERS	:	TRIP NAMES, ITINERARY NAMES, ITINERARY START DATES, ITINERARY FINISH DATES, ITINERARY POLYLINES, TRIP NUMBER
*/
CREATE PROCEDURE `listItineraries`(IN paramGoogleID VARCHAR(45), IN paramTripID VARCHAR(45), OUT resTripNames LONGTEXT, OUT resItineraryNames LONGTEXT, OUT resStartDates LONGTEXT, OUT resFinishDates LONGTEXT, OUT resItineraryPolylines LONGTEXT, OUT resItinerariesNumber INT)
SQL SECURITY INVOKER
BEGIN
	
    /*PERFORM BASIC DATA SANITISING ON DATABASE SIDE*/
	DECLARE safeGoogleID VARCHAR(45) DEFAULT UTILSANITISER(paramGoogleID, '@', '?', ' ', '');
    
	DECLARE itineraryCount INT;
	DECLARE fetchedItineraryName VARCHAR(150);
	DECLARE fetchedStartDate DATE;
	DECLARE fetchedFinishDate DATE;
	DECLARE fetchedItineraryPolyline LONGTEXT;
	DECLARE fetchedTripName VARCHAR(150);
	DECLARE fetchedTravellerID VARCHAR(45);
	DECLARE userIdentifier VARCHAR(45);

	/*DECIDE WHAT TO DO DEPENDING ON THE TRIP IDENTIFIER*/
	CASE paramTripID
	WHEN '*' THEN

		BEGIN

		/*CURSOR AND ITS HANDLER*/
		DECLARE cursorHasFinished INT DEFAULT FALSE;
		DECLARE itineraryRow CURSOR FOR SELECT `itineraryName`,`startDate`,`finishDate`,`polyline`,`tripName`,`travellerID` FROM `cursorItineraryTrip`;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET cursorHasFinished := TRUE;

		/*TEMPORARY TABLE USED TO STORE RESULTS*/
		DROP TABLE IF EXISTS `cursorTable`;
		CREATE TEMPORARY TABLE IF NOT EXISTS `cursorTable`(`itineraryName` VARCHAR(150), `startDate` DATE, `finishDate` DATE, `tripName` VARCHAR(150), `polyline` LONGTEXT, `travellerID` VARCHAR(45));

		/*CURSOR OPENING, RETRIEVAL LOOP AND CURSOR CLOSING*/
		OPEN itineraryRow;

		FETCHINGLOOP: LOOP
			FETCH itineraryRow INTO fetchedItineraryName, fetchedStartDate, fetchedFinishDate, fetchedItineraryPolyline, fetchedTripName, fetchedTravellerID;
			IF cursorHasFinished
			THEN
			  LEAVE FETCHINGLOOP;
			END IF;
			INSERT INTO `cursorTable`(`itineraryName`,`startDate`,`finishDate`,`polyline`,`tripName`,`travellerID`) VALUES (fetchedItineraryName, fetchedStartDate, fetchedFinishDate, fetchedItineraryPolyline, fetchedTripName, fetchedTravellerID);
		  END LOOP;

		CLOSE itineraryRow;

		/*ASSIGN RESULTS TO OUTPUT PARAMETERS*/
		SET userIdentifier := (SELECT `travellerID` FROM `Traveller` WHERE `userID` LIKE safeGoogleID);
		SET resItinerariesNumber := (SELECT COUNT(`itineraryName`) FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
		SET resItineraryNames := (SELECT GROUP_CONCAT(`itineraryName` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
		SET resStartDates := (SELECT GROUP_CONCAT(`startDate` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
		SET resFinishDates := (SELECT GROUP_CONCAT(`finishDate` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
		SET resTripNames := (SELECT GROUP_CONCAT(`tripName` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
		
		/*IF POLYLINES ARE EMPTY OR NULL OUTPUT DESCRIPTIVE TAG INSTEAD*/
		SET resItineraryPolylines := (SELECT GROUP_CONCAT(IFNULL(IF(`polyline` = '', 'isEmpty', `polyline`), 'isEmpty') SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);

		END;

	ELSE

		BEGIN

		/*CURSOR AND ITS HANDLER*/
		DECLARE cursorHasFinished INT DEFAULT FALSE;
		DECLARE itineraryRow CURSOR FOR SELECT `itineraryName`,`startDate`,`finishDate`,`polyline`,`tripName`,`travellerID` FROM `cursorItineraryTrip` WHERE `tripID` LIKE paramTripID;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET cursorHasFinished := TRUE;

		/*TEMPORARY TABLE USED TO STORE RESULTS*/
		DROP TABLE IF EXISTS `cursorTable`;
		CREATE TEMPORARY TABLE IF NOT EXISTS `cursorTable`(`itineraryName` VARCHAR(150), `startDate` DATE, `finishDate` DATE, `tripName` VARCHAR(150), `polyline` LONGTEXT, `travellerID` VARCHAR(45));

		/*CURSOR OPENING, RETRIEVAL LOOP AND CURSOR CLOSING*/
		OPEN itineraryRow;

		FETCHINGLOOP: LOOP
			FETCH itineraryRow INTO fetchedItineraryName, fetchedStartDate, fetchedFinishDate, fetchedItineraryPolyline, fetchedTripName, fetchedTravellerID;
			IF cursorHasFinished
			THEN
			  LEAVE FETCHINGLOOP;
			END IF;
			INSERT INTO `cursorTable`(`itineraryName`,`startDate`,`finishDate`,`polyline`,`tripName`,`travellerID`) VALUES (fetchedItineraryName, fetchedStartDate, fetchedFinishDate, fetchedItineraryPolyline, fetchedTripName, fetchedTravellerID);
		 END LOOP;

		CLOSE itineraryRow;

		/*ASSIGN RESULTS TO OUTPUT PARAMETERS*/
		SET userIdentifier := (SELECT `travellerID` FROM `Traveller` WHERE `userID` LIKE safeGoogleID);
		SET resItinerariesNumber := (SELECT COUNT(`itineraryName`) FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
		SET resItineraryNames := (SELECT GROUP_CONCAT(`itineraryName` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
		SET resStartDates := (SELECT GROUP_CONCAT(`startDate` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
		SET resFinishDates := (SELECT GROUP_CONCAT(`finishDate` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
		SET resTripNames := (SELECT GROUP_CONCAT(`tripName` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
		
		/*IF POLYLINES ARE EMPTY OR NULL OUTPUT DESCRIPTIVE TAG INSTEAD*/
		SET resItineraryPolylines := (SELECT GROUP_CONCAT(IFNULL(IF(`polyline` = '', 'isEmpty', `polyline`), 'isEmpty') SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);

		END;   
		
	END CASE;

END //
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `listFollowers`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	listFollowers
* INPUT PARAMETER 	: 	GOOGLE UNIQUE IDENTIFIER
* OUTPUT PARAMETERS	:	FOLLOWED TRIP NAMES, FOLLOWER EMAIL ADDRESSES, FOLLOWER NUMBER
*/
CREATE PROCEDURE `listFollowers`(IN paramGoogleID VARCHAR(45), OUT resTripNames LONGTEXT, OUT resEmailAddresses LONGTEXT, OUT resFollowersNumber INT)
SQL SECURITY INVOKER
BEGIN
	
    /*PERFORM BASIC DATA SANITISING ON DATABASE SIDE*/
	DECLARE safeGoogleID VARCHAR(45) DEFAULT UTILSANITISER(paramGoogleID, '@', '?', ' ', '');
    
	DECLARE fetchedUserIdentifier VARCHAR(45);
	DECLARE fetchedTripName VARCHAR(150);
	DECLARE fetchedEmailAddress VARCHAR(45);

	/*CURSOR AND ITS HANDLER*/
	DECLARE cursorHasFinished INT DEFAULT FALSE;
    DECLARE followerRow CURSOR FOR SELECT `userID`,`tripName`,`emailAddress` FROM `Follower`;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET cursorHasFinished := TRUE;
    
    /*TEMPORARY TABLE USED TO STORE RESULTS*/
	DROP TABLE IF EXISTS `cursorTable`;
	CREATE TEMPORARY TABLE IF NOT EXISTS `cursorTable`(`userID` VARCHAR(45), `tripName` VARCHAR(150), `emailAddress` VARCHAR(45));

	/*CURSOR OPENING, RETRIEVAL LOOP AND CURSOR CLOSING*/
	OPEN followerRow;

	FETCHINGLOOP: LOOP
		FETCH followerRow INTO fetchedUserIdentifier, fetchedTripName, fetchedEmailAddress;
		IF cursorHasFinished
		THEN
		  LEAVE FETCHINGLOOP;
		END IF;
		INSERT INTO `cursorTable`(`userID`,`tripName`,`emailAddress`) VALUES (fetchedUserIdentifier, fetchedTripName, fetchedEmailAddress);
	  END LOOP;

	CLOSE followerRow;
    
    SET resFollowersNumber := (SELECT COUNT(`emailAddress`) FROM `cursorTable` WHERE `userID` LIKE safeGoogleID);
    SET resTripNames := (SELECT GROUP_CONCAT(`tripName` SEPARATOR ',') FROM `cursorTable` WHERE `userID` LIKE safeGoogleID);
    SET resEmailAddresses := (SELECT GROUP_CONCAT(`emailAddress` SEPARATOR ',') FROM `cursorTable` WHERE `userID` LIKE safeGoogleID); 

END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `listFollowedTrips`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	listFollowedTrips
* INPUT PARAMETER 	: 	EMAIL ADDRESS
* OUTPUT PARAMETERS	:	FOLLOWED TRIP NAMES, FOLLOWED TRAVELLER FIRST NAMES, FOLLOWED TRAVELLER LAST NAMES, FOLLOWED TRIP START DATES, FOLLOWED TRIP FINISH DATES, FOLLOWED TRIPS NUMBER
*/
CREATE PROCEDURE `listFollowedTrips`(IN paramEmailAddress VARCHAR(45), OUT resTripNames LONGTEXT, OUT resTravellerFirstNames LONGTEXT, OUT resTravellerLastNames LONGTEXT, OUT resStartDates LONGTEXT, OUT resFinishDates LONGTEXT, OUT resFollowedTripsNumber INT)
SQL SECURITY INVOKER
BEGIN

	DECLARE fetchedEmailAddress VARCHAR(45);
	DECLARE fetchedTripName VARCHAR(150);
    DECLARE fetchedTravellerFirstName VARCHAR(45);
    DECLARE fetchedTravellerLastName VARCHAR(45);
    DECLARE fetchedStartDate DATE;
    DECLARE fetchedFinishDate DATE;

	/*CURSOR AND ITS HANDLER*/
	DECLARE cursorHasFinished INT DEFAULT FALSE;
    DECLARE followedTripsRow CURSOR FOR SELECT `emailAddress`,`tripName`,`travellerFirstName`,`travellerLastName`,`startDate`,`finishDate` FROM `cursorFollowerTrip`;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET cursorHasFinished = TRUE;
    
    /*TEMPORARY TABLE USED TO STORE RESULTS*/
	DROP TABLE IF EXISTS `cursorTable`;
	CREATE TEMPORARY TABLE IF NOT EXISTS `cursorTable`(`emailAddress` VARCHAR(45), `tripName` VARCHAR(150), `travellerFirstName` VARCHAR(45), `travellerLastName` VARCHAR(45), `startDate` DATE, `finishDate` DATE);

	/*CURSOR OPENING, RETRIEVAL LOOP AND CURSOR CLOSING*/
	OPEN followedTripsRow;

	FETCHINGLOOP: LOOP
		FETCH followedTripsRow INTO fetchedEmailAddress, fetchedTripName, fetchedTravellerFirstName, fetchedTravellerLastName, fetchedStartDate, fetchedFinishDate;
		IF cursorHasFinished
		THEN
		  LEAVE FETCHINGLOOP;
		END IF;
		INSERT INTO `cursorTable`(`emailAddress`,`tripName`,`travellerFirstName`,`travellerLastName`,`startDate`,`finishDate`) VALUES (fetchedEmailAddress, fetchedTripName, fetchedTravellerFirstName, fetchedTravellerLastName, fetchedStartDate, fetchedFinishDate);
	  END LOOP;

	CLOSE followedTripsRow;
    
    SET resFollowedTripsNumber = (SELECT COUNT(`tripName`) FROM `cursorTable` WHERE `emailAddress` LIKE paramEmailAddress);
    SET resTripNames = (SELECT GROUP_CONCAT(`tripName` SEPARATOR ',') FROM `cursorTable` WHERE `emailAddress` LIKE paramEmailAddress);
    SET resTravellerFirstNames = (SELECT GROUP_CONCAT(`travellerFirstName` SEPARATOR ',') FROM `cursorTable` WHERE `emailAddress` LIKE paramEmailAddress);
    SET resTravellerLastNames = (SELECT GROUP_CONCAT(`travellerLastName` SEPARATOR ',') FROM `cursorTable` WHERE `emailAddress` LIKE paramEmailAddress);
    SET resStartDates = (SELECT GROUP_CONCAT(`startDate` SEPARATOR ',') FROM `cursorTable` WHERE `emailAddress` LIKE paramEmailAddress);
    SET resFinishDates = (SELECT GROUP_CONCAT(`finishDate` SEPARATOR ',') FROM `cursorTable` WHERE `emailAddress` LIKE paramEmailAddress);

END //
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `listFollowedItineraries`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	listFollowedItineraries
* INPUT PARAMETERS 	: 	FOLLOWER EMAIL ADDRESS, FOLLOWED TRIP IDENTIFIER
* OUTPUT PARAMETERS	:	FOLLOWED ITINERARY NAMES, FOLLOWED TRIP NAMES, FOLLOWED ITINERARY START DATES, FOLLOWED ITINERARY FINISH DATES, FOLLOWED ITINERARY POLYLINES
*/
CREATE PROCEDURE `listFollowedItineraries`(IN paramEmailAddress VARCHAR(45), IN paramTripID VARCHAR(45), OUT resItineraryNames LONGTEXT, OUT resTripNames LONGTEXT, OUT resStartDates LONGTEXT, OUT resFinishDates LONGTEXT, OUT resItineraryPolylines LONGTEXT, OUT resFollowedItinerariesNumber INT)
SQL SECURITY INVOKER
BEGIN

	DECLARE fetchedEmailAddress VARCHAR(45);
	DECLARE fetchedItineraryName VARCHAR(150);
    DECLARE fetchedTripIdentifier VARCHAR(45);
    DECLARE fetchedTripName VARCHAR(150);
    DECLARE fetchedStartDate DATE;
    DECLARE fetchedFinishDate DATE;
    DECLARE fetchedItineraryPolyline LONGTEXT;

	/*CURSOR AND ITS HANDLER*/
	DECLARE cursorHasFinished INT DEFAULT FALSE;
    DECLARE followedTripsRow CURSOR FOR SELECT `emailAddress`,`itineraryName`,`tripID`,`tripName`,`startDate`,`finishDate`,`polyline` FROM `cursorFollowerTripItinerary` WHERE `tripID` LIKE paramTripID;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET cursorHasFinished = TRUE;
    
    /*TEMPORARY TABLE USED TO STORE RESULTS*/
	DROP TABLE IF EXISTS `cursorTable`;
	CREATE TEMPORARY TABLE IF NOT EXISTS `cursorTable`(`emailAddress` VARCHAR(45), `itineraryName` VARCHAR(150), `tripID` VARCHAR(45), `tripName` VARCHAR(150), `startDate` DATE, `finishDate` DATE, `polyline` LONGTEXT);

	/*CURSOR OPENING, RETRIEVAL LOOP AND CURSOR CLOSING*/
	OPEN followedTripsRow;

	FETCHINGLOOP: LOOP
		FETCH followedTripsRow INTO fetchedEmailAddress, fetchedItineraryName, fetchedTripIdentifier, fetchedTripName, fetchedStartDate, fetchedFinishDate, fetchedItineraryPolyline;
		IF cursorHasFinished
		THEN
		  LEAVE FETCHINGLOOP;
		END IF;
		INSERT INTO `cursorTable`(`emailAddress`,`itineraryName`,`tripID`,`tripName`,`startDate`,`finishDate`,`polyline`) VALUES (fetchedEmailAddress, fetchedItineraryName, fetchedTripIdentifier, fetchedTripName, fetchedStartDate, fetchedFinishDate, fetchedItineraryPolyline);
	  END LOOP;

	CLOSE followedTripsRow;
    
    SET resFollowedItinerariesNumber = (SELECT COUNT(`itineraryName`) FROM `cursorTable` WHERE `emailAddress` LIKE paramEmailAddress);
    SET resItineraryNames = (SELECT GROUP_CONCAT(`itineraryName` SEPARATOR ',') FROM `cursorTable` WHERE `emailAddress` LIKE paramEmailAddress);
    SET resTripNames = (SELECT GROUP_CONCAT(`tripName` SEPARATOR ',') FROM `cursorTable` WHERE `emailAddress` LIKE paramEmailAddress);
    SET resStartDates = (SELECT GROUP_CONCAT(`startDate` SEPARATOR ',') FROM `cursorTable` WHERE `emailAddress` LIKE paramEmailAddress);
    SET resFinishDates = (SELECT GROUP_CONCAT(`finishDate` SEPARATOR ',') FROM `cursorTable` WHERE `emailAddress` LIKE paramEmailAddress);
    
    /*IF POLYLINES ARE EMPTY OR NULL OUTPUT DESCRIPTIVE TAG INSTEAD*/
	SET resItineraryPolylines = (SELECT GROUP_CONCAT(IFNULL(IF(`polyline` = '', 'isEmpty', `polyline`), 'isEmpty') SEPARATOR ',') FROM `cursorTable` WHERE `emailAddress` LIKE paramEmailAddress);

END //
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
