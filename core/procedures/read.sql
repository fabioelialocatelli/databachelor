/**
* @author FABIO ELIA LOCATELLI
* @studentID 2143701
* @revisionDate 11/10/2016
* @purpose READ PROCEDURES COLLECTION
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

USE `EnRoute`;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `selectItineraryPolyline`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	selectItineraryPolyline
* INPUT PARAMETERS 	: 	GOOGLE UNIQUE IDENTIFIER, TRIP NAME, ITINERARY NAME
* OUTPUT PARAMETER	:	ITINERARY POLYLINE
*/
CREATE PROCEDURE `selectItineraryPolyline`(IN paramGoogleID VARCHAR(45), IN paramTripName VARCHAR(150), IN paramItineraryName VARCHAR(150), OUT resItineraryPolyline LONGTEXT)
SQL SECURITY INVOKER
BEGIN
	
    /*PERFORM BASIC DATA SANITISING ON DATABASE SIDE*/
	SET @safeGoogleID := utilSanitiser(paramGoogleID, '@', '?', ' ', '');
    
	/*RETRIEVES THE POLYLINE CORRESPONDING TO A CHECK IN ASSOCIATED WITH A SPECIFIC ITINERARY, IF NULL RETURNS AN EMPTY STRING*/
	SET resItineraryPolyline := (SELECT IFNULL(IF(`polyline` = '', 'isEmpty', `polyline`), 'isEmpty') 
								FROM `queryTravellerTripItinerary` 
                                WHERE `userID` LIKE @safeGoogleID 
                                AND `tripName` LIKE paramTripName 
                                AND `itineraryName` LIKE paramItineraryName);
	
END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `selectFollowedItineraryPolyline`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	selectFollowedItineraryPolyline
* INPUT PARAMETERS 	: 	FOLLOWER EMAIL ADDRESS, FOLLOWED TRIP IDENTIFIER, FOLLOWED ITINERARY NAME
* OUTPUT PARAMETER	:	FOLLOWED ITINERARY POLYLINE
*/
CREATE PROCEDURE `selectFollowedItineraryPolyline`(IN paramEmailAddress VARCHAR(45), IN paramTripID VARCHAR(45), IN paramItineraryName VARCHAR(150), OUT resFollowedItineraryPolyline LONGTEXT)
    SQL SECURITY INVOKER
BEGIN
	
    
	/*RETRIEVES THE POLYLINE CORRESPONDING TO A CHECK IN ASSOCIATED WITH A SPECIFIC ITINERARY, IF NULL RETURNS AN EMPTY STRING*/
	SET resFollowedItineraryPolyline := (SELECT IFNULL(IF(`polyline` = '', 'isEmpty', `polyline`), 'isEmpty') 
										FROM `queryFollowerTripItinerary` 
                                        WHERE `emailAddress` LIKE paramEmailAddress 
                                        AND `tripID` LIKE paramTripID
                                        AND `itineraryName` LIKE paramItineraryName);
	
END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `selectCheckInPolyline`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	selectCheckInPolyline
* INPUT PARAMETERS 	: 	GOOGLE UNIQUE IDENTIFIER, TRIP NAME, ITINERARY NAME
* OUTPUT PARAMETER	:	CHECK-IN POLYLINE
*/
CREATE PROCEDURE `selectCheckInPolyline`(IN paramGoogleID VARCHAR(45), IN paramTripName VARCHAR(150), IN paramItineraryName VARCHAR(150), OUT resCheckInPolyline LONGTEXT)
SQL SECURITY INVOKER
BEGIN
	
    /*PERFORM BASIC DATA SANITISING ON DATABASE SIDE*/
	SET @safeGoogleID := utilSanitiser(paramGoogleID, '@', '?', ' ', '');
    
	/*RETRIEVES THE POLYLINE CORRESPONDING TO A CHECK IN ASSOCIATED WITH A SPECIFIC ITINERARY, IF NULL RETURNS AN EMPTY STRING*/
	SET resCheckInPolyline := (SELECT IFNULL(IF(`polyline` = '', 'isEmpty', `polyline`), 'isEmpty')
								FROM `queryTravellerTripItineraryCheckIn` 
                                WHERE `userID` LIKE @safeGoogleID 
                                AND `tripName` LIKE paramTripName 
                                AND `itineraryName` LIKE paramItineraryName);
	
END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `selectFollowedCheckInPolyline`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	selectFollowedCheckInPolyline
* INPUT PARAMETERS 	: 	FOLLOWER EMAIL ADDRESS, FOLLOWED TRIP IDENTIFIER, FOLLOWED ITINERARY NAME
* OUTPUT PARAMETER	:	FOLLOWED CHECK-IN POLYLINE
*/
CREATE PROCEDURE `selectFollowedCheckInPolyline`(IN paramEmailAddress VARCHAR(45), IN paramTripID VARCHAR(45), IN paramItineraryName VARCHAR(150), OUT resFollowedCheckInPolyline LONGTEXT)
    SQL SECURITY INVOKER
BEGIN
	
    
	/*RETRIEVES THE POLYLINE CORRESPONDING TO A CHECK IN ASSOCIATED WITH A SPECIFIC ITINERARY, IF NULL RETURNS AN EMPTY STRING*/
	SET resFollowedCheckInPolyline := (SELECT IFNULL(IF(`polyline` = '', 'isEmpty', `polyline`), 'isEmpty') 
										FROM `queryFollowerTripItineraryCheckIn` 
                                        WHERE `emailAddress` LIKE paramEmailAddress
                                        AND `tripID` LIKE paramTripID
                                        AND `itineraryName` LIKE paramItineraryName);
	
END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `selectRecommendationPolyline`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	updateCheckInPolyline
* INPUT PARAMETER 	: 	ITINERARY UNIQUE IDENTIFIER
* OUTPUT PARAMETERS	: 	RECOMMENDATION POLYLINE, POLYLINE VERSION, POLYLINES FOUND
*/
CREATE PROCEDURE `selectRecommendationPolyline`(IN paramItineraryID VARCHAR(75), OUT resRecommendationPolyline LONGTEXT, OUT resPolylineVersion INT, OUT resPolylinesFound INT)
    SQL SECURITY INVOKER
BEGIN

	/*IF POLYLINE IS EMPTY OR NULL OUTPUT DESCRIPTIVE TAG INSTEAD*/    
	SET resRecommendationPolyline := (SELECT IFNULL(IF(`polyline` = '', 'isEmpty', `polyline`), 'isEmpty') FROM `Recommendation` WHERE `itineraryID` LIKE paramItineraryID);    
    SET resPolylineVersion := (SELECT `version` FROM `Recommendation` WHERE `itineraryID` LIKE paramItineraryID);
    
    /*COUNT HOW MANY ROWS CORRESPOND TO THAT ITINERARY IDENTIFIER, IN THIS CASE RETURNS EITHER 0 OR 1*/
    SET resPolylinesFound := (SELECT COUNT(`listID`) FROM `Recommendation` WHERE `itineraryID` LIKE paramItineraryID);

END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `logIn`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	logIn
* INPUT PARAMETERS 	: 	GOOGLE UNIQUE IDENTIFIER, USER FIRST NAME, USER LAST NAME
* OUTPUT PARAMETER 	: 	THE NUMBER OF ROWS RETURNED
*/
CREATE PROCEDURE `logIn`(IN paramGoogleID VARCHAR(45), IN paramFirstName VARCHAR(45), IN paramLastName VARCHAR(45), OUT resUsersFound INT)
    SQL SECURITY INVOKER
BEGIN

	/*PERFORM BASIC DATA SANITISING ON DATABASE SIDE*/
	SET @safeGoogleID := utilSanitiser(paramGoogleID, '@', '?', ' ', '');
    
    /*RETRIEVE CURRENT TRAVELLER NAMES FROM BOTH USER AND FOLLOWER TABLE*/
    SET @travellerFirstUser := (SELECT DISTINCT `travellerFirstUser` FROM `queryFollowerUser` WHERE `userID` LIKE @safeGoogleID);
    SET @travellerLastUser := (SELECT DISTINCT `travellerLastUser` FROM `queryFollowerUser` WHERE `userID` LIKE @safeGoogleID);
    SET @travellerFirstFollower := (SELECT DISTINCT `travellerFirstFollower` FROM `queryFollowerUser` WHERE `userID` LIKE @safeGoogleID);
    SET @travellerLastFollower := (SELECT DISTINCT `travellerLastFollower` FROM `queryFollowerUser` WHERE `userID` LIKE @safeGoogleID);
    
    /*COUNT HOW MANY ROWS CORRESPOND TO THAT USER IDENTIFIER, IN THIS CASE RETURNS EITHER 0 OR 1*/
    SET resUsersFound := (SELECT COUNT(`userID`) FROM `User` WHERE `userID` LIKE @safeGoogleID);

	/*VERIFY THAT A RECORD CORRESPONDING TO THAT GOOGLE UNIQUE IDENTIFIER EXISTS*/
    IF(resUsersFound = 1)
	THEN		
		START TRANSACTION;
			/*VERIFY THAT THE TRAVELLER NAMES IN THE USER TABLE ARE NOT THE SAME AS THE SUBMITTED ONES*/
			IF (@travellerFirstUser NOT LIKE paramFirstName OR @travellerLastUser NOT LIKE paramLastName)
				THEN
					START TRANSACTION;
						UPDATE `User` 
						SET 
							`firstName` = paramFirstName,
							`lastName` = paramLastName
						WHERE `userID` LIKE @safeGoogleID;
					COMMIT;
			END IF;
			
			/*VERIFY THAT THE TRAVELLER NAMES EXIST IN THE FOLLOWER TABLE, CONDITION NOT MET FOR NEW ACCOUNTS*/
			IF (@travellerFirstFollower IS NOT NULL OR @travellerLastFollower IS NOT NULL)
			THEN
				/*VERIFY THAT THE TRAVELLER NAMES IN THE FOLLOWER TABLE ARE NOT THE SAME AS THE SUBMITTED ONES*/
				IF(@travellerFirstFollower NOT LIKE paramFirstName OR @travellerLastFollower NOT LIKE paramLastName)
					THEN
						START TRANSACTION;							
							UPDATE `Follower`
							SET 
								`travellerFirstName` = paramFirstName,
								`travellerLastName` = paramLastName 
							WHERE `userID` LIKE @safeGoogleID;                        
						COMMIT;
				END IF;
			END IF;
        COMMIT;
	END IF;
    
END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
