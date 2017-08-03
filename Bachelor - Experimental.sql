/**
* @author FABIO ELIA LOCATELLI
* @studentID 2143701
* @revisionDate 11/10/2016
* @purpose EXPERIMENTAL CODE COLLECTION
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*AMOUNT OF ITINERARIES ASSOCIATED WITH A SPECIFIC ACCOUNT*/
SELECT 
    COUNT(itineraryAlias.itineraryID)
FROM
    `Trip` tripAlias
        LEFT JOIN
    `Itinerary` itineraryAlias ON tripAlias.tripID = itineraryAlias.tripID
        LEFT JOIN
    `Traveller` travellerAlias ON tripAlias.travellerID = travellerAlias.travellerID
WHERE
    travellerAlias.userID LIKE '101594866096129072852';
    
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

SELECT 
    COUNT(itineraryAlias.itineraryID)
FROM
    `Trip` tripAlias
        LEFT JOIN
    `Itinerary` itineraryAlias ON tripAlias.tripID = itineraryAlias.tripID
        LEFT JOIN
    `Traveller` travellerAlias ON tripAlias.travellerID = travellerAlias.travellerID
WHERE
    travellerAlias.userID LIKE '101594866096129072852'
        AND tripAlias.tripID LIKE RETURNTRIPIDENTIFIER('Auckland to Rangiwahia',
            '101594866096129072852');
            
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

SELECT DISTINCT
    itineraryAlias.itineraryName,
    itineraryAlias.startDate,
    itineraryAlias.finishDate,
    tripAlias.travellerID
FROM
    `Trip` tripAlias
        LEFT JOIN
    `Itinerary` itineraryAlias ON itineraryAlias.tripID = tripAlias.tripID
WHERE
    itineraryAlias.itineraryName IS NOT NULL;
    
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

SELECT DISTINCT
    itineraryAlias.itineraryName,
    itineraryAlias.startDate,
    itineraryAlias.finishDate,
    tripAlias.travellerID
FROM
    `Trip` tripAlias
        LEFT JOIN
    `Itinerary` itineraryAlias ON itineraryAlias.tripID = tripAlias.tripID
WHERE
    itineraryAlias.itineraryName IS NOT NULL
        AND tripAlias.tripID LIKE RETURNTRIPIDENTIFIER('Auckland to Rangiwahia',
            '101594866096129072852');
            
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
            
SELECT 
    itineraryAlias.itineraryID
FROM
    `Itinerary` itineraryAlias
        LEFT JOIN
    `Trip` tripAlias ON tripAlias.tripID = itineraryAlias.tripID
WHERE
    tripAlias.tripID LIKE RETURNTRIPIDENTIFIER('Auckland to Rangiwahia',
            '101594866096129072852')
        AND itineraryAlias.itineraryName LIKE 'Auckland to Meremere';
        
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*THE OLD returnItineraryCount() FUNCTION*/
DROP FUNCTION IF EXISTS returnItineraryCount;
DELIMITER //
CREATE FUNCTION returnItineraryCount(paramTripID VARCHAR(45)) RETURNS TEXT READS SQL DATA
SQL SECURITY INVOKER
BEGIN

SET @itineraryCount = (SELECT COUNT(`itineraryID`) FROM `Itinerary` WHERE `tripID` LIKE paramTripID);

RETURN(@itineraryCount);
END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
        
/*THE OLD createItinerary() PROCEDURE*/
DROP PROCEDURE IF EXISTS `createItinerary`;
DELIMITER //
CREATE PROCEDURE `createItinerary`(IN paramTripID VARCHAR(45), IN paramItineraryName VARCHAR(45), IN paramStartDate DATE, IN paramFinishDate DATE, IN paramInitialPolyline LONGTEXT, OUT resAffectedRows INT)
SQL SECURITY INVOKER
BEGIN

SET @itineraryCount = (SELECT COUNT(`itineraryID`) FROM `Itinerary`);
SET @formattedTimestamp = FORMATCURRENTTIMESTAMP(10);
SET @itineraryID = CONCAT(paramTripID, '_', @itineraryCount, '_', @formattedTimestamp);

IF NOT EXISTS (SELECT `itineraryName` FROM `Itinerary` WHERE `tripID` LIKE paramTripID AND `itineraryName` LIKE paramItineraryName)
THEN
	START TRANSACTION;
		INSERT INTO `Itinerary`(`itineraryID`,`polyline`,`itineraryName`,`startDate`, `finishDate`, `tripID`) VALUES (@itineraryID, paramInitialPolyline, paramItineraryName, paramStartDate, paramFinishDate, paramTripID);
	COMMIT;
	SET resAffectedRows = 1;
ELSE
	SET resAffectedRows = 0;
END IF;  
END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*THE OLD listTrips() PROCEDURE*/
DROP PROCEDURE IF EXISTS `listTrips`;
DELIMITER //
CREATE PROCEDURE `listTrips`(IN paramGoogleID VARCHAR(45), OUT resTripNames TEXT, OUT resStartDates TEXT, OUT resFinishDates TEXT, OUT resTripsCount INT)
SQL SECURITY INVOKER
BEGIN

DECLARE tripCount INT;
DECLARE fetchedTripName VARCHAR(45);
DECLARE fetchedStartDate DATE;
DECLARE fetchedFinishDate DATE;
DECLARE fetchedTravellerID VARCHAR(45);
DECLARE userIdentifier VARCHAR(45);

/*CURSOR AND ITS HANDLER*/
DECLARE cursorHasFinished INT DEFAULT FALSE;
DECLARE tripRow CURSOR FOR SELECT 
    COUNT(itineraryAlias.itineraryID),
    tripAlias.tripName,
    tripAlias.startDate,
    tripAlias.finishDate,
    tripAlias.travellerID
FROM
    `Trip` tripAlias
        LEFT JOIN
    `Itinerary` itineraryAlias ON tripAlias.tripID = itineraryAlias.tripID
        LEFT JOIN
    `Traveller` travellerAlias ON tripAlias.travellerID = travellerAlias.travellerID
WHERE
    travellerAlias.userID LIKE paramGoogleID
        AND tripAlias.tripID LIKE RETURNTRIPIDENTIFIER('Auckland to Rangiwahia',
            '101594866096129072852');
DECLARE CONTINUE HANDLER FOR NOT FOUND SET cursorHasFinished = TRUE;

/*TEMPORARY TABLE USED TO STORE RESULTS*/
DROP TABLE IF EXISTS `cursorTable`;
CREATE TEMPORARY TABLE IF NOT EXISTS `cursorTable`(`tripName` VARCHAR(45), `startDate` DATE, `finishDate` DATE, `travellerID` VARCHAR(45));

/*CURSOR OPENING, RETRIEVAL LOOP AND CURSOR CLOSING*/    
OPEN tripRow;

FETCHINGLOOP: LOOP
    FETCH tripRow INTO fetchedTripName, fetchedStartDate, fetchedFinishDate, fetchedTravellerID;
    IF cursorHasFinished
    THEN
      LEAVE FETCHINGLOOP;
    END IF;
    INSERT INTO `cursorTable`(`tripName`,`startDate`,`finishDate`,`travellerID`) VALUES (fetchedTripName, fetchedStartDate, fetchedFinishDate, fetchedTravellerID);
  END LOOP;
  
CLOSE tripRow;

/*ASSIGN RESULTS TO OUTPUT PARAMETERS*/
SET userIdentifier = (SELECT `travellerID` FROM `Traveller` WHERE `userID` LIKE paramGoogleID);
SET resTripsCount = (SELECT COUNT(`tripName`) FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
SET resTripNames = (SELECT GROUP_CONCAT(`tripName` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
SET resStartDates = (SELECT GROUP_CONCAT(`startDate` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
SET resFinishDates = (SELECT GROUP_CONCAT(`finishDate` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);

END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*THE OLD listItineraries() PROCEDURE*/
DROP PROCEDURE IF EXISTS `listItineraries`;
DELIMITER //
CREATE PROCEDURE `listItineraries`(IN paramGoogleID VARCHAR(45), IN paramTripID VARCHAR(45), OUT resItineraryNames TEXT, OUT resStartDates TEXT, OUT resFinishDates TEXT, OUT resItinerariesCount INT)
SQL SECURITY INVOKER
BEGIN

DECLARE itineraryCount INT;
DECLARE fetchedItineraryName VARCHAR(45);
DECLARE fetchedStartDate DATE;
DECLARE fetchedFinishDate DATE;
DECLARE fetchedTravellerID VARCHAR(45);
DECLARE userIdentifier VARCHAR(45);

/*DECIDE WHAT TO DO DEPENDING ON THE TRIP IDENTIFIER*/
CASE paramTripID
WHEN '*' THEN

	BEGIN

	/*CURSOR AND ITS HANDLER*/
	DECLARE cursorHasFinished INT DEFAULT FALSE;

	DECLARE itineraryRow CURSOR FOR SELECT DISTINCT itineraryAlias.itineraryName, itineraryAlias.startDate, itineraryAlias.finishDate, tripAlias.travellerID FROM `Trip` tripAlias 
	LEFT JOIN `Itinerary` itineraryAlias ON itineraryAlias.tripID = tripAlias.tripID WHERE itineraryAlias.itineraryName IS NOT NULL;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET cursorHasFinished = TRUE;

	/*TEMPORARY TABLE USED TO STORE RESULTS*/
	DROP TABLE IF EXISTS `cursorTable`;
	CREATE TEMPORARY TABLE IF NOT EXISTS `cursorTable`(`itineraryName` VARCHAR(45), `startDate` DATE, `finishDate` DATE, `travellerID` VARCHAR(45));

	/*CURSOR OPENING, RETRIEVAL LOOP AND CURSOR CLOSING*/
	OPEN itineraryRow;

	FETCHINGLOOP: LOOP
		FETCH itineraryRow INTO fetchedItineraryName, fetchedStartDate, fetchedFinishDate, fetchedTravellerID;
		IF cursorHasFinished
		THEN
		  LEAVE FETCHINGLOOP;
		END IF;
		INSERT INTO `cursorTable`(`itineraryName`,`startDate`,`finishDate`,`travellerID`) VALUES (fetchedItineraryName, fetchedStartDate, fetchedFinishDate, fetchedTravellerID);
	  END LOOP;

	CLOSE itineraryRow;

	/*ASSIGN RESULTS TO OUTPUT PARAMETERS*/
	SET userIdentifier = (SELECT `travellerID` FROM `Traveller` WHERE `userID` LIKE paramGoogleID);
	SET resItinerariesCount = (SELECT COUNT(`itineraryName`) FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
	SET resItineraryNames = (SELECT GROUP_CONCAT(`itineraryName` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
	SET resStartDates = (SELECT GROUP_CONCAT(`startDate` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
	SET resFinishDates = (SELECT GROUP_CONCAT(`finishDate` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);

	END;

ELSE

	BEGIN

	/*CURSOR AND ITS HANDLER*/
	DECLARE cursorHasFinished INT DEFAULT FALSE;

	DECLARE itineraryRow CURSOR FOR SELECT DISTINCT itineraryAlias.itineraryName, itineraryAlias.startDate, itineraryAlias.finishDate, tripAlias.travellerID FROM `Trip` tripAlias 
	LEFT JOIN `Itinerary` itineraryAlias ON itineraryAlias.tripID = tripAlias.tripID WHERE itineraryAlias.itineraryName IS NOT NULL AND tripAlias.tripID LIKE paramTripID;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET cursorHasFinished = TRUE;

	/*TEMPORARY TABLE USED TO STORE RESULTS*/
	DROP TABLE IF EXISTS `cursorTable`;
	CREATE TEMPORARY TABLE IF NOT EXISTS `cursorTable`(`itineraryName` VARCHAR(45), `startDate` DATE, `finishDate` DATE, `travellerID` VARCHAR(45));

	/*CURSOR OPENING, RETRIEVAL LOOP AND CURSOR CLOSING*/
	OPEN itineraryRow;

	FETCHINGLOOP: LOOP
		FETCH itineraryRow INTO fetchedItineraryName, fetchedStartDate, fetchedFinishDate, fetchedTravellerID;
		IF cursorHasFinished
		THEN
		  LEAVE FETCHINGLOOP;
		END IF;
		INSERT INTO `cursorTable`(`itineraryName`,`startDate`,`finishDate`,`travellerID`) VALUES (fetchedItineraryName, fetchedStartDate, fetchedFinishDate, fetchedTravellerID);
	  END LOOP;

	CLOSE itineraryRow;

	/*ASSIGN RESULTS TO OUTPUT PARAMETERS*/
	SET userIdentifier = (SELECT `travellerID` FROM `Traveller` WHERE `userID` LIKE paramGoogleID);
	SET resItinerariesCount = (SELECT COUNT(`itineraryName`) FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
	SET resItineraryNames = (SELECT GROUP_CONCAT(`itineraryName` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
	SET resStartDates = (SELECT GROUP_CONCAT(`startDate` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
	SET resFinishDates = (SELECT GROUP_CONCAT(`finishDate` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);

	END;   
    
END CASE;

END //
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*THE OLD listItineraries() PROCEDURE*/
DROP PROCEDURE IF EXISTS `listItineraries`;
DELIMITER //
CREATE PROCEDURE `listItineraries`(IN paramGoogleID VARCHAR(45), IN paramTripID VARCHAR(45), OUT resItineraryNames TEXT, OUT resStartDates TEXT, OUT resFinishDates TEXT, OUT resItinerariesCount INT)
SQL SECURITY INVOKER
BEGIN

DECLARE itineraryCount INT;
DECLARE fetchedItineraryName VARCHAR(45);
DECLARE fetchedStartDate DATE;
DECLARE fetchedFinishDate DATE;
DECLARE fetchedTravellerID VARCHAR(45);
DECLARE userIdentifier VARCHAR(45);

/*DECIDE WHAT TO DO DEPENDING ON THE TRIP IDENTIFIER*/
CASE paramTripID
WHEN '*' THEN

	BEGIN

	/*CURSOR AND ITS HANDLER*/
	DECLARE cursorHasFinished INT DEFAULT FALSE;

	DECLARE itineraryRow CURSOR FOR SELECT DISTINCT itineraryAlias.itineraryName, itineraryAlias.startDate, itineraryAlias.finishDate, tripAlias.travellerID FROM `Trip` tripAlias 
	LEFT JOIN `Itinerary` itineraryAlias ON itineraryAlias.tripID = tripAlias.tripID WHERE itineraryAlias.itineraryName IS NOT NULL;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET cursorHasFinished = TRUE;

	/*TEMPORARY TABLE USED TO STORE RESULTS*/
	DROP TABLE IF EXISTS `cursorTable`;
	CREATE TEMPORARY TABLE IF NOT EXISTS `cursorTable`(`itineraryName` VARCHAR(45), `startDate` DATE, `finishDate` DATE, `travellerID` VARCHAR(45));

	/*CURSOR OPENING, RETRIEVAL LOOP AND CURSOR CLOSING*/
	OPEN itineraryRow;

	FETCHINGLOOP: LOOP
		FETCH itineraryRow INTO fetchedItineraryName, fetchedStartDate, fetchedFinishDate, fetchedTravellerID;
		IF cursorHasFinished
		THEN
		  LEAVE FETCHINGLOOP;
		END IF;
		INSERT INTO `cursorTable`(`itineraryName`,`startDate`,`finishDate`,`travellerID`) VALUES (fetchedItineraryName, fetchedStartDate, fetchedFinishDate, fetchedTravellerID);
	  END LOOP;

	CLOSE itineraryRow;

	/*ASSIGN RESULTS TO OUTPUT PARAMETERS*/
	SET userIdentifier = (SELECT `travellerID` FROM `Traveller` WHERE `userID` LIKE paramGoogleID);
	SET resItinerariesCount = (SELECT COUNT(`itineraryName`) FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
	SET resItineraryNames = (SELECT GROUP_CONCAT(`itineraryName` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
	SET resStartDates = (SELECT GROUP_CONCAT(`startDate` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
	SET resFinishDates = (SELECT GROUP_CONCAT(`finishDate` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);

	END;

ELSE

	BEGIN

	/*CURSOR AND ITS HANDLER*/
	DECLARE cursorHasFinished INT DEFAULT FALSE;

	DECLARE itineraryRow CURSOR FOR SELECT DISTINCT itineraryAlias.itineraryName, itineraryAlias.startDate, itineraryAlias.finishDate, tripAlias.travellerID FROM `Trip` tripAlias 
	LEFT JOIN `Itinerary` itineraryAlias ON itineraryAlias.tripID = tripAlias.tripID WHERE itineraryAlias.itineraryName IS NOT NULL AND tripAlias.tripID LIKE paramTripID;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET cursorHasFinished = TRUE;

	/*TEMPORARY TABLE USED TO STORE RESULTS*/
	DROP TABLE IF EXISTS `cursorTable`;
	CREATE TEMPORARY TABLE IF NOT EXISTS `cursorTable`(`itineraryName` VARCHAR(45), `startDate` DATE, `finishDate` DATE, `travellerID` VARCHAR(45));

	/*CURSOR OPENING, RETRIEVAL LOOP AND CURSOR CLOSING*/
	OPEN itineraryRow;

	FETCHINGLOOP: LOOP
		FETCH itineraryRow INTO fetchedItineraryName, fetchedStartDate, fetchedFinishDate, fetchedTravellerID;
		IF cursorHasFinished
		THEN
		  LEAVE FETCHINGLOOP;
		END IF;
		INSERT INTO `cursorTable`(`itineraryName`,`startDate`,`finishDate`,`travellerID`) VALUES (fetchedItineraryName, fetchedStartDate, fetchedFinishDate, fetchedTravellerID);
	  END LOOP;

	CLOSE itineraryRow;

	/*ASSIGN RESULTS TO OUTPUT PARAMETERS*/
	SET userIdentifier = (SELECT `travellerID` FROM `Traveller` WHERE `userID` LIKE paramGoogleID);
	SET resItinerariesCount = (SELECT COUNT(`itineraryName`) FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
	SET resItineraryNames = (SELECT GROUP_CONCAT(`itineraryName` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
	SET resStartDates = (SELECT GROUP_CONCAT(`startDate` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);
	SET resFinishDates = (SELECT GROUP_CONCAT(`finishDate` SEPARATOR ',') FROM `cursorTable` WHERE `travellerID` LIKE userIdentifier);

	END;   
    
END CASE;

END //
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*THE OLD updateTripDetails() PROCEDURE*/
DROP PROCEDURE IF EXISTS `updateTripDetails`;
DELIMITER //
CREATE PROCEDURE `updateTripDetails`(IN paramGoogleID VARCHAR(45), IN paramTripID VARCHAR(45), IN paramTripName VARCHAR(150), IN paramStartDate DATE, IN paramFinishDate DATE, OUT resAffectedRows INT)
SQL SECURITY INVOKER
BEGIN

/*TRANSACTION RESPONSIBLE OF UPDATING START AND FINISH DATES*/
START TRANSACTION;
	UPDATE `Trip` 
SET 
    `startDate` = paramStartDate,
    `finishDate` = paramFinishDate
WHERE
    `tripID` = paramTripID;     
     
/*VERIFY THAT A TRIP WITH THE SAME NAME IS NOT ASSOCIATED WITH THE CURRENT ACCOUNT*/
IF NOT EXISTS (SELECT `tripName` FROM `tripUserView` WHERE `userID` LIKE paramGoogleID AND `tripName` LIKE paramTripName)
THEN
    
    /*NESTED TRANSACTION RESPONSIBLE OF UPDATING TRIP NAME*/
    START TRANSACTION;
		UPDATE `Trip` 
SET 
    `tripName` = paramTripName
WHERE
    `tripID` = paramTripID; 
    
END IF;

SET resAffectedRows = ROW_COUNT();

COMMIT;

END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*THE OLD updateItineraryDetails() PROCEDURE*/
DROP PROCEDURE IF EXISTS `updateItineraryDetails`;
DELIMITER //
CREATE PROCEDURE `updateItineraryDetails`(IN paramGoogleID VARCHAR(45), IN paramItineraryID VARCHAR(75), IN paramItineraryName VARCHAR(150), IN paramStartDate DATE, IN paramFinishDate DATE, OUT resAffectedRows INT)
SQL SECURITY INVOKER
BEGIN

/*TRANSACTION RESPONSIBLE OF UPDATING START AND FINISH DATES*/
START TRANSACTION;
	UPDATE `Itinerary` 
SET 
    `startDate` = paramStartDate,
    `finishDate` = paramFinishDate
WHERE
    `itineraryID` = paramItineraryID;     
     
/*VERIFY THAT AN ITINERARY WITH THE SAME NAME IS NOT ASSOCIATED WITH THE CURRENT ACCOUNT*/
IF NOT EXISTS (SELECT `itineraryName` FROM `itineraryUserView` WHERE `userID` LIKE paramGoogleID AND `itineraryName` LIKE paramItineraryName)
THEN
    
    /*NESTED TRANSACTION RESPONSIBLE OF UPDATING TRIP NAME*/
    START TRANSACTION;
		UPDATE `Itinerary` 
SET 
    `itineraryName` = paramItineraryName
WHERE
    `itineraryID` = paramItineraryID; 
    
END IF;

SET resAffectedRows = ROW_COUNT();

COMMIT;

END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

SELECT GROUP_CONCAT(`polyline` SEPARATOR ',') FROM `Itinerary`;
SELECT GROUP_CONCAT(IF(`polyline` = '', 'isEmpty', `polyline`) SEPARATOR ',') FROM `Itinerary`;
SELECT GROUP_CONCAT(IFNULL(`polyline`, 'isNull') SEPARATOR ',') FROM `Itinerary`;
SELECT GROUP_CONCAT(IFNULL(IF(`polyline` = '', 'isEmpty', `polyline`), 'isNull') SEPARATOR ',') FROM `Itinerary`;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

SELECT STRCMP((SELECT `tripName` FROM `queryTravellerUserTrip` WHERE `userID` LIKE '101594866096129072852' AND `tripName` LIKE 'Mombasa to Namibia'), RETURNTRIPNAME('101594866096129072852', RETURNTRIPIDENTIFIER('101594866096129072852', 'Mombasa to Namibia')));
SELECT STRCMP((SELECT `tripName` FROM `queryTravellerUserTrip` WHERE `userID` LIKE '101594866096129072852' AND `tripName` LIKE 'Milan to Barcelona'), RETURNTRIPNAME('101594866096129072852', RETURNTRIPIDENTIFIER('101594866096129072852', 'Mombasa to Namibia')));
SELECT (STRCMP('Kirth', 'Kirth') + STRCMP('Gersen', 'Gersen'));
SELECT (STRCMP('Kirth', 'Dirk') + STRCMP('Gersen', 'Gersen'));
SELECT (STRCMP('Kirth', 'Dirk') + STRCMP('Gersen', 'Pitt'));
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

SELECT REPLACE('raisins@sunsweet.com', '@', '');
SELECT REPLACE(REPLACE('raisins@sunsweet.com', '@', ''),'.','');
SELECT MODIFYCASE(1, REPLACE(REPLACE('raisins@sunsweet.com', '@', ''),'.',''));
SELECT UCASE(REPLACE(SANITISESEQUENCE('raisins@sunsweet.com', '@', '', ' ', ''),'.',''));
SELECT UCASE(REPLACE('Auckland to Manawatu',' ',''));
SELECT `followerID` FROM `Follower` WHERE `followerID` LIKE 'raisins@sunsweet.com' AND `tripID` LIKE RETURNTRIPIDENTIFIER('101594866096129072852', 'Auckland to Manawatu');

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*THE OLD returnItineraryIdentifier() FUNCTION*/
DROP FUNCTION IF EXISTS returnItineraryIdentifier;
DELIMITER //
CREATE FUNCTION returnItineraryIdentifier(paramGoogleID VARCHAR(45), paramTripName VARCHAR(45), paramItineraryName VARCHAR(65)) RETURNS VARCHAR(65) READS SQL DATA
SQL SECURITY INVOKER
BEGIN

SET @itineraryID = (SELECT 
    itineraryAlias.itineraryID
FROM
    `Itinerary` itineraryAlias
        LEFT JOIN
    `Trip` tripAlias ON tripAlias.tripID = itineraryAlias.tripID
WHERE
    tripAlias.tripID LIKE RETURNTRIPIDENTIFIER(paramGoogleID, 
            paramTripName)
        AND itineraryAlias.itineraryName LIKE paramItineraryName);

RETURN(@itineraryID);

END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*THE OLD addFollower() PROCEDURE*/
DROP PROCEDURE IF EXISTS `addFollower`;
DELIMITER //
CREATE PROCEDURE `addFollower`(IN paramGoogleID VARCHAR(45), IN paramEmailAddress VARCHAR(45), IN paramTripID VARCHAR(45), OUT resAffectedRows INT)
BEGIN

/*PERFORM BASIC DATA SANITISING ON DATABASE SIDE*/
SET @safeGoogleID = SANITISESEQUENCE(paramGoogleID, '@', '?', ' ', '');
SET @safeTripID = SANITISESEQUENCE(paramTripID, '@', '?', ' ', '');

/*RETRIEVE TRAVELLER IDENTIFIER DEPENDING ON CURRENT TRIP AND USER*/
SET @tripName = (SELECT `tripName` FROM `followerView` WHERE `tripID` LIKE @safeTripID AND `userID` LIKE @safeGoogleID);
SET @travellerID = (SELECT `travellerID` FROM `followerView` WHERE `tripID` LIKE @safeTripID AND `userID` LIKE @safeGoogleID);
SET @travellerName = (SELECT CONCAT(`firstName`, ' ', `lastName`) FROM `followerView` WHERE `tripID` LIKE @safeTripID AND `userID` LIKE @safeGoogleID);

/*GENERATE FOLLOWER IDENTIFIER, BASED ON EMAIL ADDRESS, TRIP NAME, AMOUNT OF FOLLOWERS AND TIMESTAMP */
SET @modifiedEmail = UCASE(REPLACE(SANITISESEQUENCE(paramEmailAddress, '@', '', ' ', ''),'.',''));
SET @modifedTripName = TRUNCATESTRING(1, UCASE(REPLACE(@tripName,' ','')), 15);
SET @formattedTimestamp = FORMATCURRENTTIMESTAMP(10);
SET @followerCount = (SELECT COUNT(`followerID`) FROM `Follower`);
SET @followerID = CONCAT('FOLLOWER', '_', @modifedTripName, @followerCount, '_@_', @formattedTimestamp);

/*VERIFY THAT THE FOLLOWER IS NOT ALREADY ASSOCIATED WITH A SPECIFIC TRIP*/
IF NOT EXISTS(SELECT `emailAddress` FROM `Follower` WHERE `tripID` LIKE @safeTripID AND `emailAddress` LIKE paramEmailAddress)
THEN
START TRANSACTION;
	INSERT INTO `Follower`(`followerID`,`userID`,`tripID`,`travellerID`,`tripName`,`travellerName`, `emailAddress`) VALUES (@followerID, @safeGoogleID, @safeTripID, @travellerID, @tripName, @travellerName, paramEmailAddress);
	SET resAffectedRows = ROW_COUNT();
COMMIT;

ELSE
	SET resAffectedRows = ROW_COUNT();
    ROLLBACK;
END IF;

END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `returnRecommendationIdentifiers`;
DELIMITER //
CREATE PROCEDURE `returnRecommendationIdentifiers`(IN paramEmailAddress VARCHAR(45), IN paramTripName VARCHAR(150), IN paramTripStartDate DATE, IN paramTripFinishDate DATE, IN paramItineraryName VARCHAR(150), IN paramItineraryStartDate DATE, IN paramItineraryFinishDate DATE, OUT resItineraryID VARCHAR(75), OUT resFollowerID VARCHAR(45))
SQL SECURITY INVOKER
BEGIN

	SET resItineraryID = (SELECT `itineraryID` FROM `queryFollowerTripItinerary` WHERE
	`emailAddress` LIKE paramEmailAddress AND
	`tripName` LIKE paramTripName AND
	`tripStartDate` LIKE paramTripStartDate AND
	`tripFinishDate` LIKE paramTripFinishDate AND
	`itineraryName` LIKE paramItineraryName AND
	`itineraryStartDate` LIKE paramItineraryStartDate AND
	`itineraryFinishDate` LIKE paramItineraryFinishDate);
        
	SET resFollowerID = (SELECT `followerID` FROM `queryFollowerTripItinerary` WHERE
    `emailAddress` LIKE paramEmailAddress AND
    `tripName` LIKE paramTripName AND
    `tripStartDate` LIKE paramTripStartDate AND
    `tripFinishDate` LIKE paramTripFinishDate AND
    `itineraryName` LIKE paramItineraryName AND
    `itineraryStartDate` LIKE paramItineraryStartDate AND
    `itineraryFinishDate` LIKE paramItineraryFinishDate);     
    
END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS `logIn`;
DELIMITER //
CREATE PROCEDURE `logIn`(IN paramGoogleID VARCHAR(45), OUT resAffectedRows INT)
SQL SECURITY INVOKER
BEGIN

	/*PERFORM BASIC DATA SANITISING ON DATABASE SIDE*/
	SET @safeGoogleID = SANITISESEQUENCE(paramGoogleID, '@', '?', ' ', '');

	/*CHECKS WHETHER A RECORD CORRESPONDING TO THAT ACCOUNT EXISTS*/
	IF (SELECT EXISTS (SELECT 1 FROM `User` WHERE @safeGoogleID LIKE `userID`))
	THEN 
		SET resAffectedRows = 1;
	ELSE 
		SET resAffectedRows = 0;
	END IF;
    
END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP VIEW IF EXISTS `queryFollowerTripItinerary`;
CREATE VIEW `queryFollowerTripItinerary` AS
    SELECT 
		followerAlias.followerID AS `followerID`,
        followerAlias.emailAddress AS `emailAddress`,
        tripAlias.tripID AS `tripID`,
        tripAlias.tripName AS `tripName`,
        tripAlias.startDate AS `tripStartDate`,
        tripAlias.finishDate AS `tripFinishDate`,
        itineraryAlias.itineraryID AS `itineraryID`,
        itineraryAlias.itineraryName AS `itineraryName`,
        itineraryAlias.startDate AS `itineraryStartDate`,
        itineraryAlias.finishDate AS `itineraryFinishDate`
    FROM
        `Follower` followerAlias
            LEFT JOIN
        `Trip` tripAlias ON tripAlias.tripID =  followerAlias.tripID
            LEFT JOIN
        `Itinerary` itineraryAlias ON itineraryAlias.tripID = tripAlias.tripID;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
