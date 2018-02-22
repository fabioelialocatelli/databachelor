/**
* @author FABIO ELIA LOCATELLI
* @studentID 2143701
* @revisionDate 11/10/2016
* @purpose CURSOR VIEWS COLLECTION
*------------------------------------------------------------------------------------------------------------------------------------------------------*/

USE `EnRoute`;

/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

/*VIEW REQUIRED BY OUTER CURSOR IN listTrips() STORED PROCEDURE*/
DROP VIEW IF EXISTS `cursorTrip`;
CREATE VIEW `cursorTrip` AS
    SELECT 
        tripAlias.tripName AS `tripName`,
        tripAlias.startDate AS `startDate`,
        tripAlias.finishDate AS `finishDate`,
        tripAlias.travellerID AS `travellerID`
    FROM
        `Trip` tripAlias;        
        
/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

/*VIEW REQUIRED BY INNER CURSOR IN listTrips() STORED PROCEDURE*/
DROP VIEW IF EXISTS `cursorTripItineraryTraveller`;
CREATE VIEW `cursorTripItineraryTraveller` AS
SELECT
		tripAlias.tripID AS `tripID`,
        tripAlias.tripName AS `tripName`,
        itineraryAlias.itineraryID AS `itineraryID`,
        itineraryAlias.itineraryName AS `itineraryName`,
        travellerAlias.userID AS `userID`
        
	FROM
		`Trip` tripAlias
			LEFT JOIN
		`Itinerary` itineraryAlias ON tripAlias.tripID = itineraryAlias.tripID
			LEFT JOIN
		`Traveller` travellerAlias ON tripAlias.travellerID = travellerAlias.travellerID; 

/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

/*VIEW REQUIRED BY CURSOR IN listItineraries() STORED PROCEDURE*/
DROP VIEW IF EXISTS `cursorItineraryTrip`;
CREATE VIEW `cursorItineraryTrip` AS
    SELECT 
		itineraryAlias.itineraryID AS `itineraryID`,
        itineraryAlias.itineraryName AS `itineraryName`,
        itineraryAlias.startDate AS `startDate`,
        itineraryAlias.finishDate AS `finishDate`,
        itineraryAlias.polyline AS `polyline`,
        tripAlias.tripID AS `tripID`,
        tripAlias.tripName AS `tripName`,
        tripAlias.travellerID AS `travellerID`
    FROM
        `Trip` tripAlias
            LEFT JOIN
        `Itinerary` itineraryAlias ON itineraryAlias.tripID = tripAlias.tripID
    WHERE
        itineraryAlias.itineraryName IS NOT NULL;
        
/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

/*VIEW REQUIRED BY CURSOR IN listFollowedTrips() STORED PROCEDURE*/
DROP VIEW IF EXISTS `cursorFollowerTrip`;
CREATE VIEW `cursorFollowerTrip` AS
    SELECT 
        followerAlias.emailAddress AS `emailAddress`,
        followerAlias.travellerFirstName AS `travellerFirstName`,
        followerAlias.travellerLastName AS `travellerLastName`,
        tripAlias.tripName AS `tripName`,
        tripAlias.startDate AS `startDate`,
        tripAlias.finishDate AS `finishDate`
    FROM
        `Follower` followerAlias
            LEFT JOIN
        `Trip` tripAlias ON tripAlias.tripID = followerAlias.tripID;
        
/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

/*VIEW REQUIRED BY CURSOR IN listFollowedItineraries() STORED PROCEDURE*/
DROP VIEW IF EXISTS `cursorFollowerTripItinerary`;
CREATE VIEW `cursorFollowerTripItinerary` AS
    SELECT 
        followerAlias.emailAddress AS `emailAddress`,
        followerAlias.travellerFirstName AS `travellerFirstName`,
        followerAlias.travellerLastName AS `travellerLastName`,
        tripAlias.tripID AS `tripID`,
        tripAlias.tripName AS `tripName`,
        itineraryAlias.itineraryName AS `itineraryName`,
        itineraryAlias.startDate AS `startDate`,
        itineraryAlias.finishDate AS `finishDate`,
        itineraryAlias.polyline AS `polyline`
    FROM
        `Follower` followerAlias
            LEFT JOIN
        `Trip` tripAlias ON tripAlias.tripID = followerAlias.tripID
            LEFT JOIN
        `Itinerary` itineraryAlias ON itineraryAlias.tripID = followerAlias.tripID;
        
/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/
