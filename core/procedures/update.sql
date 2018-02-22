/**
* @author FABIO ELIA LOCATELLI
* @studentID 2143701
* @revisionDate 11/10/2016
* @purpose UPDATE PROCEDURES COLLECTION
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

USE `EnRoute`;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `updateTripDetails`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	updateTripDetails
* INPUT PARAMETERS 	: 	GOOGLE UNIQUE IDENTIFIER, TRIP UNIQUE IDENTIFIER, TRIP NAME, TRIP START DATE, TRIP FINISH DATE
* OUTPUT PARAMETER 	: 	THE NUMBER OF ROWS RETURNED
*/
CREATE PROCEDURE `updateTripDetails`(IN paramGoogleID VARCHAR(45), IN paramTripID VARCHAR(45), IN paramTripName VARCHAR(150), IN paramStartDate DATE, IN paramFinishDate DATE, OUT resAffectedRows INT)
    SQL SECURITY INVOKER
BEGIN

	/*PERFORM BASIC DATA SANITISING ON DATABASE SIDE*/
	DECLARE safeGoogleID VARCHAR(45) DEFAULT utilSanitiser(paramGoogleID, '@', '?', ' ', '');
	DECLARE fetchedTripName VARCHAR(150);

	/*CURSOR AND ITS HANDLER*/
	DECLARE cursorHasFinished INT DEFAULT FALSE;

	/*RETRIEVE ALL TRIPS ASSOCIATED WITH THE CURRENT ACCOUNT BUT THE ONE BEING EDITED*/
	DECLARE viewRow CURSOR FOR SELECT `tripName` FROM `queryTravellerTrip` WHERE `userID` LIKE safeGoogleID AND `tripID` NOT IN(paramTripID);
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET cursorHasFinished := TRUE;

	/*TEMPORARY TABLE USED TO STORE RESULTS*/
	DROP TABLE IF EXISTS `cursorTable`;
	CREATE TEMPORARY TABLE IF NOT EXISTS `cursorTable`(`tripName` VARCHAR(150));

	/*CURSOR OPENING, RETRIEVAL LOOP AND CURSOR CLOSING*/  
	OPEN viewRow;

	FETCHINGLOOP: LOOP
			FETCH viewRow INTO fetchedTripName;
			IF cursorHasFinished
			THEN
			  LEAVE FETCHINGLOOP;
			END IF;
			INSERT INTO `cursorTable`(`tripName`) VALUES (fetchedTripName);
		  END LOOP;

	CLOSE viewRow;

	/*TRANSACTION RESPONSIBLE FOR TRIP DETAILS MODIFICATION*/
	START TRANSACTION;
		/*VERIFY THAT A TRIP WITH THE SAME NAME DOES NOT EXIST*/
		IF NOT EXISTS(SELECT `tripName` FROM `cursorTable` WHERE `tripName` LIKE paramTripName)
		THEN
			UPDATE `Trip` 
			SET 
				`startDate` = paramStartDate,
				`finishDate` = paramFinishDate,
				`tripName` = paramTripName
			WHERE `tripID` = paramTripID;
			
			/*UPDATES THE TRIP DETAILS WHEN FOUND IN THE FOLLOWER TABLE*/
			IF EXISTS(SELECT `followerID` FROM `Follower` WHERE `tripID` LIKE paramTripID)
			THEN
				UPDATE `Follower` 
				SET `tripName` = paramTripName
				WHERE `tripID` = paramTripID;
			END IF;
		END IF;
		/*RETURNS THE NUMBER OF ROWS AFFECTED BY THE LAST STATEMENT, NOT BY THE WHOLE PROCEDURE*/
		SET resAffectedRows := ROW_COUNT();
	COMMIT;
    
END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `updateItineraryDetails`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	updateItineraryDetails
* INPUT PARAMETERS 	: 	GOOGLE UNIQUE IDENTIFIER, ITINERARY UNIQUE IDENTIFIER, ITINERARY NAME, ITINERARY START DATE, ITINERARY FINISH DATE
* OUTPUT PARAMETER 	: 	THE NUMBER OF ROWS RETURNED
*/
CREATE PROCEDURE `updateItineraryDetails`(IN paramGoogleID VARCHAR(45), IN paramItineraryID VARCHAR(75), IN paramItineraryName VARCHAR(150), IN paramStartDate DATE, IN paramFinishDate DATE, OUT resAffectedRows INT)
SQL SECURITY INVOKER
BEGIN

	/*PERFORM BASIC DATA SANITISING ON DATABASE SIDE*/
	DECLARE safeGoogleID VARCHAR(45) DEFAULT utilSanitiser(paramGoogleID, '@', '?', ' ', '');
	DECLARE fetchedItineraryName VARCHAR(150);

	/*CURSOR AND ITS HANDLER*/
	DECLARE cursorHasFinished INT DEFAULT FALSE;

	/*RETRIEVE ALL ITINERARIES ASSOCIATED WITH THE CURRENT ACCOUNT BUT THE ONE BEING EDITED*/
	DECLARE viewRow CURSOR FOR SELECT `itineraryName` FROM `queryTravellerTripItinerary` WHERE `userID` LIKE safeGoogleID AND `itineraryID` NOT LIKE paramItineraryID;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET cursorHasFinished := TRUE;

	/*TEMPORARY TABLE USED TO STORE RESULTS*/
	DROP TABLE IF EXISTS `cursorTable`;
	CREATE TEMPORARY TABLE IF NOT EXISTS `cursorTable`(`itineraryName` VARCHAR(150));

	/*CURSOR OPENING, RETRIEVAL LOOP AND CURSOR CLOSING*/  
	OPEN viewRow;

	FETCHINGLOOP: LOOP
			FETCH viewRow INTO fetchedItineraryName;
			IF cursorHasFinished
			THEN
			  LEAVE FETCHINGLOOP;
			END IF;
			INSERT INTO `cursorTable`(`itineraryName`) VALUES (fetchedItineraryName);
		  END LOOP;

	CLOSE viewRow;

	START TRANSACTION;
		/*VERIFY THAT AN ITINERARY WITH THE SAME NAME DOES NOT EXIST*/
		IF NOT EXISTS(SELECT `itineraryName` FROM `cursorTable` WHERE `itineraryName` LIKE paramItineraryName)
		THEN			
			UPDATE `Itinerary` 
			SET 
				`startDate` = paramStartDate,
				`finishDate` = paramFinishDate,
				`itineraryName` = paramItineraryName
			WHERE `itineraryID` = paramItineraryID;

		END IF;
		/*RETURNS THE NUMBER OF ROWS AFFECTED BY THE LAST STATEMENT, NOT BY THE WHOLE PROCEDURE*/
		SET resAffectedRows := ROW_COUNT();
	COMMIT;
    
END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `updateItineraryPolyline`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	updateItineraryPolyline
* INPUT PARAMETERS 	: 	ITINERARY UNIQUE IDENTIFIER, ITINERARY POLYLINE
* OUTPUT PARAMETER 	: 	THE NUMBER OF ROWS RETURNED
*/
CREATE PROCEDURE `updateItineraryPolyline`(IN paramItineraryID VARCHAR(75), IN paramPlannedPolyline LONGTEXT, OUT resAffectedRows INT)
SQL SECURITY INVOKER
BEGIN

	/*A MERE UPDATE OPERATION, WHICH RETURNS THE AMOUNT OF ROWS AFFECTED*/
	START TRANSACTION;
		UPDATE `Itinerary` SET `polyline` = paramPlannedPolyline WHERE `itineraryID` = paramItineraryID;
		SET resAffectedRows := ROW_COUNT();
	COMMIT;

END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `updateCheckInPolyline`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	updateCheckInPolyline
* INPUT PARAMETERS 	: 	ITINERARY UNIQUE IDENTIFIER, CHECK-IN POLYLINE
* OUTPUT PARAMETER 	: 	THE NUMBER OF ROWS RETURNED
*/
CREATE PROCEDURE `updateCheckInPolyline`(IN paramItineraryID VARCHAR(75), IN paramCheckInPolyline LONGTEXT, OUT resAffectedRows INT)
SQL SECURITY INVOKER
BEGIN

	/*A MERE UPDATE OPERATION, WHICH RETURNS THE AMOUNT OF ROWS AFFECTED*/
	START TRANSACTION;
		UPDATE `CheckIn` SET `polyline` = paramCheckInPolyline WHERE `itineraryID` = paramItineraryID;
		SET resAffectedRows := ROW_COUNT();
	COMMIT;

END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `updateRecommendationPolyline`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	updateCheckInPolyline
* INPUT PARAMETERS 	: 	ITINERARY UNIQUE IDENTIFIER, RECOMMENDATION POLYLINE, POLYLINE VERSION
* OUTPUT PARAMETER 	: 	THE NUMBER OF ROWS RETURNED
*/
CREATE PROCEDURE `updateRecommendationPolyline`(IN paramItineraryID VARCHAR(75), IN paramRecommendationPolyline LONGTEXT, IN paramPolylineVersion INT, OUT resAffectedRows INT)
    SQL SECURITY INVOKER
BEGIN

	START TRANSACTION;    
		SET @currentVersion := (SELECT `version` FROM `Recommendation` WHERE `itineraryID` LIKE paramItineraryID);
		
		/*CONDITION MET WHEN ITINERARY IDENTIFIER IS INVALID*/
		IF (@currentVersion IS NOT NULL)
		THEN
			/*BOOLEAN VALUE RESULTING FROM VERSION COMPARISON*/
			SET @versionMatching := (SELECT @currentVersion = paramPolylineVersion);		
			
			/*DEPENDING ON VERSION MATCH DECIDE WHICH OPERATION TO PERFORM*/
			CASE @versionMatching
				WHEN 0
					THEN 
					ROLLBACK;
				WHEN 1
					THEN 
					UPDATE `Recommendation` 
					SET 
						`polyline` = paramRecommendationPolyline,
						`version` = @currentVersion + 1
					WHERE `itineraryID` = paramItineraryID;
			END CASE;
				
		END IF;
        /*RETURNS THE NUMBER OF ROWS AFFECTED BY THE LAST STATEMENT, NOT BY THE WHOLE PROCEDURE*/
		SET resAffectedRows := ROW_COUNT();
	COMMIT;

END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
