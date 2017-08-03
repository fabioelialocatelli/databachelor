/**
* @author FABIO ELIA LOCATELLI
* @studentID 2143701
* @revisionDate 11/10/2016
* @purpose QUERY VIEWS COLLECTION
*------------------------------------------------------------------------------------------------------------------------------------------------------*/

USE `EnRoute`;

/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

/*VIEW REQUIRED BY logIn() STORED PROCEDURE*/
DROP VIEW IF EXISTS `queryFollowerUser`;
CREATE VIEW `queryFollowerUser` AS
	SELECT
		followerAlias.followerID AS `followerID`,
		followerAlias.emailAddress AS `emailAddress`,
		followerAlias.travellerFirstName AS`travellerFirstFollower`,
		followerAlias.travellerLastName AS`travellerLastFollower`,
		userAlias.userID AS `userID`,
		userAlias.firstName AS `travellerFirstUser`,
		userAlias.lastName AS `travellerLastUser`
	FROM 
		`Follower` followerAlias
		RIGHT JOIN
		`User` userAlias ON userAlias.userID = followerAlias.userID;
    
/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

/*VIEW REQUIRED BY selectItineraryPolyline() and updateItineraryDetails() STORED PROCEDURES*/
DROP VIEW IF EXISTS `queryTravellerTripItinerary`;
CREATE VIEW `queryTravellerTripItinerary` AS
	SELECT
		travellerAlias.userID AS `userID`,
        travellerAlias.travellerID AS `travellerID`,
        tripAlias.tripID AS `tripID`,
        tripAlias.tripName AS `tripName`,
        itineraryAlias.itineraryID AS `itineraryID`,
        itineraryAlias.itineraryName AS `itineraryName`,
        itineraryAlias.polyline AS `polyline`
	FROM
        `Traveller` travellerAlias
            LEFT JOIN
        `Trip` tripAlias ON tripAlias.travellerID = travellerAlias.travellerID
            LEFT JOIN
        `Itinerary` itineraryAlias ON itineraryAlias.tripID = tripAlias.tripID;
        
/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

/*VIEW REQUIRED BY selectFollowedItineraryPolyline() STORED PROCEDURE*/
DROP VIEW IF EXISTS `queryFollowerTripItinerary`;
CREATE VIEW `queryFollowerTripItinerary` AS
    SELECT 
        followerAlias.emailAddress AS `emailAddress`,
        tripAlias.tripID AS `tripID`,
        tripAlias.tripName AS `tripName`,
        itineraryAlias.itineraryID AS `itineraryID`,
        itineraryAlias.itineraryName AS `itineraryName`,
        itineraryAlias.polyline AS `polyline`
    FROM
        `Follower` followerAlias
            LEFT JOIN
        `Trip` tripAlias ON tripAlias.tripID =  followerAlias.tripID
            LEFT JOIN
        `Itinerary` itineraryAlias ON itineraryAlias.tripID = tripAlias.tripID;
        
/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

/*VIEW REQUIRED BY selectCheckInPolyline() STORED PROCEDURE*/
DROP VIEW IF EXISTS `queryTravellerTripItineraryCheckIn`;
CREATE VIEW `queryTravellerTripItineraryCheckIn` AS
    SELECT 
        travellerAlias.userID AS `userID`,
        travellerAlias.travellerID AS `travellerID`,
        tripAlias.tripID AS `tripID`,
        tripAlias.tripName AS `tripName`,
        itineraryAlias.itineraryID AS `itineraryID`,
        itineraryAlias.itineraryName AS `itineraryName`,
        checkInAlias.listID AS `listID`,
        checkInAlias.polyline AS `polyline`
    FROM
        `Traveller` travellerAlias
            LEFT JOIN
        `Trip` tripAlias ON tripAlias.travellerID = travellerAlias.travellerID
            LEFT JOIN
        `Itinerary` itineraryAlias ON itineraryAlias.tripID = tripAlias.tripID
            LEFT JOIN
        `CheckIn` checkInAlias ON checkInAlias.itineraryID = itineraryAlias.itineraryID; 
 
/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/
 
/*VIEW REQUIRED BY selectFollowedCheckInPolyline() STORED PROCEDURE*/
DROP VIEW IF EXISTS `queryFollowerTripItineraryCheckIn`;
CREATE VIEW `queryFollowerTripItineraryCheckIn` AS
    SELECT 
        followerAlias.emailAddress AS `emailAddress`,
        tripAlias.tripID AS `tripID`,
        tripAlias.tripName AS `tripName`,
        itineraryAlias.itineraryID AS `itineraryID`,
        itineraryAlias.itineraryName AS `itineraryName`,
        checkInAlias.listID AS `listID`,
        checkInAlias.polyline AS `polyline`
    FROM
        `Follower` followerAlias
            LEFT JOIN
        `Trip` tripAlias ON tripAlias.tripID =  followerAlias.tripID
            LEFT JOIN
        `Itinerary` itineraryAlias ON itineraryAlias.tripID = tripAlias.tripID
            LEFT JOIN
        `CheckIn` checkInAlias ON checkInAlias.itineraryID = itineraryAlias.itineraryID;

/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

/*VIEW REQUIRED BY updateTripDetails() STORED PROCEDURE*/
DROP VIEW IF EXISTS `queryTravellerTrip`;
CREATE VIEW `queryTravellerTrip` AS
	SELECT
		travellerAlias.userID AS `userID`,
		travellerAlias.travellerID AS `travellerID`,
        tripAlias.tripID AS `tripID`,
        tripAlias.tripName AS `tripName`
	FROM
		`Traveller` travellerAlias
            LEFT JOIN
        `Trip` tripAlias ON tripAlias.travellerID = travellerAlias.travellerID;
        
/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

/*VIEW REQUIRED BY addFollower() STORED PROCEDURE*/
DROP VIEW IF EXISTS `queryTravellerUserTrip`;
CREATE VIEW `queryTravellerUserTrip` AS
    SELECT 
        travellerAlias.userID AS `userID`,
        travellerAlias.travellerID AS `travellerID`,
        userAlias.firstName AS `firstName`,
        userAlias.lastName AS `lastName`,
        tripAlias.tripID AS `tripID`,
        tripAlias.tripName AS `tripName`
    FROM
        `Traveller` travellerAlias
            LEFT JOIN
        `User` userAlias ON userAlias.userID = travellerAlias.userID
            LEFT JOIN
        `Trip` tripAlias ON tripAlias.travellerID = travellerAlias.travellerID;
        
/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

/*VIEW REQUIRED BY unfollowTrip() STORED PROCEDURE*/
DROP VIEW IF EXISTS `queryFollowerTripUser`;
CREATE VIEW `queryFollowerTripUser` AS
    SELECT 
        followerAlias.followerID AS `followerID`,
        followerAlias.emailAddress AS `emailAddress`,
        tripAlias.tripID AS `tripID`,
        tripAlias.tripName AS `tripName`,
        userAlias.userID AS `userID`
    FROM
        `Follower` followerAlias
            LEFT JOIN
        `Trip` tripAlias ON tripAlias.tripID = followerAlias.tripID
            LEFT JOIN
        `User` userAlias ON userAlias.userID = followerAlias.userID;

/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

/*VIEW REQUIRED BY returnItineraryIdentifier() STORED FUNCTION*/
DROP VIEW IF EXISTS `queryItineraryTrip`;
CREATE VIEW `queryItineraryTrip` AS
    SELECT 
        itineraryAlias.itineraryID AS `itineraryID`,
        itineraryAlias.itineraryName AS `itineraryName`,
        tripAlias.tripID AS `tripID`,
        tripAlias.tripName AS `tripName`
    FROM
        `Itinerary` itineraryAlias
            LEFT JOIN
        `Trip` tripAlias ON tripAlias.tripID = itineraryAlias.tripID;

/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

/*VIEW REQUIRED BY returnFollowedTripIdentifier() STORED FUNCTION*/
DROP VIEW IF EXISTS `queryTripFollower`;
CREATE VIEW `queryTripFollower` AS
    SELECT 
        tripAlias.tripID AS `tripID`,
        tripAlias.tripName AS `tripName`,
        tripAlias.startDate AS `startDate`,
        tripAlias.finishDate AS `finishDate`,
        followerAlias.emailAddress AS `emailAddress`,
        followerAlias.travellerFirstName AS `travellerFirstName`,
        followerAlias.travellerLastName AS `travellerLastName`
    FROM
        `Trip` tripAlias
            LEFT JOIN
        `Follower` followerAlias ON followerAlias.tripID = tripAlias.tripID;
    
/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

/*VIEW REQUIRED BY returnFollowedItineraryIdentifier() STORED FUNCTION*/
DROP VIEW IF EXISTS `queryTripItineraryFollower`;
CREATE VIEW `queryTripItineraryFollower` AS
    SELECT 
        tripAlias.tripID AS `tripID`,
        tripAlias.tripName AS `tripName`,
        itineraryAlias.itineraryID AS `itineraryID`,
        itineraryAlias.itineraryName AS `itineraryName`,
        itineraryAlias.startDate AS `startDate`,
        itineraryAlias.finishDate AS `finishDate`,
        followerAlias.emailAddress AS `emailAddress`,
        followerAlias.travellerFirstName AS `travellerFirstName`,
        followerAlias.travellerLastName AS `travellerLastName`
    FROM
        `Trip` tripAlias
        LEFT JOIN
        `Itinerary` itineraryAlias ON itineraryAlias.tripID = tripAlias.tripID
            LEFT JOIN
        `Follower` followerAlias ON followerAlias.tripID = tripAlias.tripID;
    
/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/
