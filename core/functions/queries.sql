/**
* @author FABIO ELIA LOCATELLI
* @studentID 2143701
* @revisionDate 11/10/2016
* @purpose QUERY FUNCTIONS COLLECTION
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

USE `EnRoute`;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP FUNCTION IF EXISTS `returnTripIdentifier`;
DELIMITER //
/*
* FUNCTION NAME   	: 	returnTripIdentifier
* INPUT PARAMETERS 	: 	UNIQUE GOOGLE IDENTIFIER, TRIP NAME
* OUTPUT PARAMETER 	: 	TRIP IDENTIFIER
*/
CREATE FUNCTION `returnTripIdentifier`(paramGoogleID VARCHAR(45), paramTripName VARCHAR(45)) RETURNS VARCHAR(45) READS SQL DATA
SQL SECURITY INVOKER
BEGIN

	SET @travellerID := (SELECT `travellerID` FROM `Traveller` WHERE `userID` LIKE paramGoogleID);
	SET @tripID := (SELECT `tripID` FROM `Trip` WHERE `travellerID` LIKE @travellerID AND `tripName` LIKE paramTripName);

	RETURN(@tripID);

END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP FUNCTION IF EXISTS `returnFollowedTripIdentifier`;
DELIMITER //
/*
* FUNCTION NAME   	: 	returnFollowedTripIdentifier
* INPUT PARAMETERS 	: 	TRIP START DATE, TRIP FINISH DATE, TRIP NAME, FOLLOWER EMAIL ADDRESS, TRAVELLER FIRST NAME, TRAVELLER LAST NAME
* OUTPUT PARAMETER 	: 	TRIP IDENTIFIER
*/
CREATE FUNCTION `returnFollowedTripIdentifier`(paramStartDate DATE, paramFinishDate DATE, paramTripName VARCHAR(150), paramEmailAddress VARCHAR(45), paramFirstName VARCHAR(45), paramLastName VARCHAR(45)) RETURNS VARCHAR(45) READS SQL DATA
SQL SECURITY INVOKER
BEGIN

	SET @followedTripID := (SELECT `tripID` FROM `queryTripFollower` WHERE
    `startDate` LIKE paramStartDate
        AND `finishDate` LIKE paramFinishDate
        AND `tripName` LIKE paramTripName
        AND `emailAddress` LIKE paramEmailAddress
        AND `travellerFirstName` LIKE paramFirstName
        AND `travellerLastName` LIKE  paramLastName );
        
	RETURN(@followedTripID);

END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
   
DROP FUNCTION IF EXISTS `returnItineraryIdentifier`;
DELIMITER //
/*
* FUNCTION NAME   	: 	returnItineraryIdentifier
* INPUT PARAMETERS 	: 	UNIQUE GOOGLE IDENTIFIER, TRIP NAME, ITINERARY NAME
* OUTPUT PARAMETER 	: 	ITINERARY IDENTIFIER
*/
CREATE FUNCTION `returnItineraryIdentifier`(paramGoogleID VARCHAR(45), paramTripName VARCHAR(150), paramItineraryName VARCHAR(65)) RETURNS VARCHAR(75) READS SQL DATA
SQL SECURITY INVOKER
BEGIN

	SET @tripID := returnTripIdentifier(paramGoogleID, paramTripName);
	SET @itineraryID := (SELECT `itineraryID` FROM `queryItineraryTrip` WHERE `tripID` LIKE @tripID AND `itineraryName` LIKE paramItineraryName);

	RETURN(@itineraryID);

END//
DELIMITER ;

     

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP FUNCTION IF EXISTS `returnFollowedItineraryIdentifier`;
DELIMITER //
/*
* FUNCTION NAME   	: 	returnFollowedTripIdentifier
* INPUT PARAMETERS 	: 	ITINERARY START DATE, ITINERARY FINISH DATE, TRIP NAME, ITINERARY NAME, FOLLOWER EMAIL ADDRESS, TRAVELLER FIRST NAME, TRAVELLER LAST NAME
* OUTPUT PARAMETER 	: 	TRIP IDENTIFIER
*/
CREATE FUNCTION `returnFollowedItineraryIdentifier`(paramStartDate DATE, paramFinishDate DATE, paramTripName VARCHAR(150), paramItineraryName VARCHAR(150), paramEmailAddress VARCHAR(45), paramFirstName VARCHAR(45), paramLastName VARCHAR(45)) RETURNS VARCHAR(75) READS SQL DATA
SQL SECURITY INVOKER
BEGIN

	SET @followedItineraryID := (SELECT `itineraryID` FROM `queryTripItineraryFollower` WHERE
    `startDate` LIKE paramStartDate
        AND `finishDate` LIKE paramFinishDate
        AND `tripName` LIKE paramTripName
        AND `itineraryName` LIKE paramItineraryName
        AND `emailAddress` LIKE paramEmailAddress
        AND `travellerFirstName` LIKE paramFirstName
        AND `travellerLastName` LIKE  paramLastName );
        
	RETURN(@followedItineraryID);

END//
DELIMITER ;        

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP FUNCTION IF EXISTS `returnTripName`;
DELIMITER //
/*
* FUNCTION NAME   	: 	returnTripName
* INPUT PARAMETERS 	: 	UNIQUE GOOGLE IDENTIFIER, TRIP IDENTIFIER
* OUTPUT PARAMETER 	: 	TRIP NAME
*/
CREATE FUNCTION `returnTripName`(paramGoogleID VARCHAR(45), paramTripID VARCHAR(45)) RETURNS VARCHAR(150) READS SQL DATA
SQL SECURITY INVOKER
BEGIN

	SET @tripName := (SELECT `tripName` FROM `queryTravellerUserTrip` WHERE `userID` LIKE paramGoogleID AND `tripID` LIKE paramTripID);

	RETURN(@tripName);

END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
