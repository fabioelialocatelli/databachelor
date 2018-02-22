/**
* @author FABIO ELIA LOCATELLI
* @studentID 2143701
* @revisionDate 11/10/2016
* @purpose DELETE PROCEDURES COLLECTION
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

USE `EnRoute`;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `deleteAccount`;
DELIMITER //
/*
* PROCEDURE NAME   	:	deleteAccount
* INPUT PARAMETERS 	: 	GOOGLE UNIQUE IDENTIFIER
* OUTPUT PARAMETER 	: 	THE NUMBER OF ROWS RETURNED
*/
CREATE PROCEDURE `deleteAccount`(IN paramGoogleID VARCHAR(45), OUT resAffectedRows INT)
SQL SECURITY INVOKER
BEGIN    
    
    /*CURRENT FOLLOWER IDENTIFIER*/
	DECLARE currentFollowerID VARCHAR(45);

	/*CURSOR AND ITS HANDLER*/
	DECLARE cursorHasFinished INT DEFAULT FALSE;
	DECLARE followerID CURSOR FOR SELECT `followerID` FROM `Follower`;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET cursorHasFinished := TRUE;
    
    /*PERFORM BASIC DATA SANITISING ON DATABASE SIDE*/
	SET @safeGoogleID := utilSanitiser(paramGoogleID, '@', '?', ' ', '');
    
    /*RETRIEVE GOOGLE UNIQUE IDENTIFIER AND EMAIL ADDRESS FROM THE USER TABLE*/
    SET @userIdentifier := (SELECT `userID` FROM `User` WHERE `userID` LIKE @safeGoogleID);
    SET @emailAddress := (SELECT `emailAddress` FROM `User` WHERE `userID` LIKE @safeGoogleID);

	START TRANSACTION;
		IF(@userIdentifier IS NOT NULL AND @emailAddress IS NOT NULL)
        THEN			
			/*CURSOR OPENING, RETRIEVAL LOOP AND CURSOR CLOSING*/  
			OPEN followerID;

			FETCHINGLOOP: LOOP
					FETCH followerID INTO currentFollowerID;
					IF cursorHasFinished
					THEN
					  LEAVE FETCHINGLOOP;
					END IF;
					DELETE FROM `Follower` WHERE `FollowerID` LIKE currentFollowerID AND `emailAddress` LIKE @emailAddress;
				  END LOOP;

			CLOSE followerID;
			
			DELETE FROM `User` WHERE `userID` LIKE @userIdentifier;
		END IF;
        /*RETURNS THE NUMBER OF ROWS AFFECTED BY THE LAST STATEMENT, NOT BY THE WHOLE PROCEDURE*/
		SET resAffectedRows := ROW_COUNT();
	COMMIT;		

END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `deleteTrip`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	deleteTrip
* INPUT PARAMETERS 	: 	TRIP UNIQUE IDENTIFIER
* OUTPUT PARAMETER 	: 	THE NUMBER OF ROWS RETURNED
*/
CREATE PROCEDURE `deleteTrip`(IN paramTripID VARCHAR(45), OUT resAffectedRows INT)
SQL SECURITY INVOKER
BEGIN

	/*A MERE DELETE OPERATION, WHICH RETURNS THE AMOUNT OF ROWS AFFECTED*/
	START TRANSACTION;
		DELETE FROM `Trip` WHERE `tripID` = paramTripID;
		SET resAffectedRows = ROW_COUNT();
	COMMIT;

END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `deleteItinerary`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	deleteItinerary
* INPUT PARAMETERS 	: 	ITINERARY UNIQUE IDENTIFIER
* OUTPUT PARAMETER 	: 	THE NUMBER OF ROWS RETURNED
*/
CREATE PROCEDURE `deleteItinerary`(IN paramItineraryID VARCHAR(75), OUT resAffectedRows INT)
SQL SECURITY INVOKER
BEGIN

	/*A MERE DELETE OPERATION, WHICH RETURNS THE AMOUNT OF ROWS AFFECTED*/
	START TRANSACTION;
		DELETE FROM `Itinerary` WHERE `itineraryID` = paramItineraryID;
		SET resAffectedRows = ROW_COUNT();
	COMMIT;

END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `deleteFollower`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	deleteFollower
* INPUT PARAMETERS 	: 	GOOGLE UNIQUE IDENTIFIER, FOLLOWER EMAIL ADDRESS, TRIP IDENTIFIER
* OUTPUT PARAMETER	:	RETURNED ROWS
*/
CREATE PROCEDURE `deleteFollower`(IN paramGoogleID VARCHAR(45), IN paramEmailAddress VARCHAR(45), IN paramTripID VARCHAR(45), OUT resAffectedRows INT)
SQL SECURITY INVOKER
BEGIN

	/*PERFORM BASIC DATA SANITISING ON DATABASE SIDE*/
	DECLARE safeGoogleID VARCHAR(45) DEFAULT utilSanitiser(paramGoogleID, '@', '?', ' ', '');

	START TRANSACTION;
		/*VERIFY THAT THE FOLLOWER IS ASSOCIATED TO THE CURRENT TRIP AND USER ACCOUNT*/
		IF EXISTS(SELECT `emailAddress` FROM `Follower` WHERE `userID` LIKE safeGoogleID AND `emailAddress` LIKE paramEmailAddress AND `tripID` LIKE paramTripID)
		THEN
        
		DELETE FROM `Follower` 
		WHERE
			`userID` LIKE safeGoogleID
			AND `emailAddress` LIKE paramEmailAddress
			AND `tripID` LIKE paramTripID;
			
		END IF;
		/*RETURNS THE NUMBER OF ROWS AFFECTED BY THE LAST STATEMENT, NOT BY THE WHOLE PROCEDURE*/
		SET resAffectedRows := ROW_COUNT();
	COMMIT;
    
END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `unfollowTrip`;
DELIMITER //
/*
* PROCEDURE NAME   	: 	deleteFollower
* INPUT PARAMETERS 	: 	FOLLOWER EMAIL ADDRESS, TRIP IDENTIFIER
* OUTPUT PARAMETER	:	RETURNED ROWS
*/
CREATE PROCEDURE `unfollowTrip` (IN paramEmailAddress VARCHAR(45), IN paramTripID VARCHAR(150), OUT resAffectedRows INT)
SQL SECURITY INVOKER
BEGIN
	
    /*RETRIEVE THE GOOGLE IDENTIFIER FROM A DATABASE VIEW*/
	SET @googleID := (SELECT `userID` FROM `queryFollowerTripUser` WHERE `emailAddress` LIKE paramEmailAddress AND `tripID` LIKE paramTripID);
	
    START TRANSACTION;
    /*VERIFY THAT THE FOLLOWER IS ASSOCIATED TO THE CURRENT TRIP AND USER ACCOUNT*/
		IF EXISTS(SELECT `emailAddress` FROM `Follower` WHERE `userID` LIKE @googleID AND `emailAddress` LIKE paramEmailAddress AND `tripID` LIKE paramTripID)
		THEN
		
		DELETE FROM `Follower` 
		WHERE
			`userID` LIKE @googleID
			AND `emailAddress` LIKE paramEmailAddress
			AND `tripID` LIKE paramTripID;			
			
		END IF;
		/*RETURNS THE NUMBER OF ROWS AFFECTED BY THE LAST STATEMENT, NOT BY THE WHOLE PROCEDURE*/
		SET resAffectedRows := ROW_COUNT();
    COMMIT;
    
END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
