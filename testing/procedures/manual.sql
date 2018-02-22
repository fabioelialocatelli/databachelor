/**
* @author FABIO ELIA LOCATELLI
* @studentID 2143701
* @revisionDate 11/10/2016
* @purpose MANUAL PROCEDURE TEST CASES COLLECTION
*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

USE `EnRoute`;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*DELETE SPECIFIED ACCOUNT*/
CALL deleteAccount('101594866096129072852', @returnedRows); #TRAVELLER
CALL deleteAccount('101594866096129072853', @returnedRows); #FOLLOWER
CALL deleteAccount('101594866096129072854', @returnedRows); #FOLLOWER
CALL deleteAccount('101594866096129072855', @returnedRows); #FOLLOWER
SELECT @returnedRows;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*CREATE SPECIFIED ACCOUNT*/
CALL createAccount('101594866096129072852', 'me@milkyway.com', 'Kirth', 'Gersen', @returnedRows);
CALL createAccount('101594866096129072853', 'raisins@sunsweet.com', 'Raisins', 'Sunsweet', @returnedRows);
CALL createAccount('101594866096129072854', 'sultanas@sunsweet.com', 'Sultanas', 'Sunsweet', @returnedRows);
CALL createAccount('101594866096129072855', 'prunes@sunsweet.com', 'Prunes', 'Sunsweet', @returnedRows);
SELECT @returnedRows;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*ATTEMPT LOGIN*/
CALL logIn('101594866096129072856', 'Kirth', 'Gersen', @returnedRows); #USER INEXISTENT
CALL logIn('101594866096129072852', 'Kirth', 'Gersen', @returnedRows); #USER UNCHANGED
CALL logIn('101594866096129072852', 'Dirk', 'Gersen', @returnedRows); #USER FIRST NAME CHANGED
CALL logIn('101594866096129072852', 'Kirth', 'Pitt', @returnedRows); #USER LAST NAME CHANGED
CALL logIn('101594866096129072852', 'Dirk', 'Pitt', @returnedRows); #USER FIRST AND LAST CHANGED
SELECT @returnedRows;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*CREATE TRIPS*/
CALL createTrip('101594866096129072852', 'Mombasa to Namibia', '2016-08-25', '2017-08-25', @returnedRows);
CALL createTrip('101594866096129072852', 'Auckland to Rangiwahia', '2016-08-25', '2016-08-25', @returnedRows);
CALL createTrip('101594866096129072852', 'Milan to Barcelona', '2016-08-25', '2016-08-26', @returnedRows);
SELECT @returnedRows;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*CREATE ITINERARIES*/
CALL createItinerary(RETURNTRIPIDENTIFIER('101594866096129072852', 'Mombasa to Namibia'), 'Mombasa to Diani Beach', '2016-08-25', '2016-08-26', @returnedRows); 
CALL createItinerary(RETURNTRIPIDENTIFIER('101594866096129072852', 'Mombasa to Namibia'), 'Diani Beach to Msambweni', '2016-08-26', '2016-08-27', @returnedRows);
CALL createItinerary(RETURNTRIPIDENTIFIER('101594866096129072852', 'Mombasa to Namibia'), 'Msambweni to Lunga-Lunga', '2016-08-27', '2016-08-28', @returnedRows);
CALL createItinerary(RETURNTRIPIDENTIFIER('101594866096129072852', 'Mombasa to Namibia'), 'Lunga-Lunga to Fish Eagle Point', '2016-08-28', '2016-08-29', @returnedRows);
CALL createItinerary(RETURNTRIPIDENTIFIER('101594866096129072852', 'Mombasa to Namibia'), 'Fish Eagle Point to Tanga', '2016-08-29', '2016-08-30', @returnedRows);
CALL createItinerary(RETURNTRIPIDENTIFIER('101594866096129072852', 'Mombasa to Namibia'), 'Tanga to Peponi Beach', '2016-08-30', '2016-08-31', @returnedRows);
CALL createItinerary(RETURNTRIPIDENTIFIER('101594866096129072852', 'Auckland to Rangiwahia'), 'Auckland to Meremere', '2016-09-01', '2016-09-01', @returnedRows);
CALL createItinerary(RETURNTRIPIDENTIFIER('101594866096129072852', 'Auckland to Rangiwahia'), 'Meremere to Ngaruawahia', '2016-09-01', '2016-09-01', @returnedRows);
CALL createItinerary(RETURNTRIPIDENTIFIER('101594866096129072852', 'Auckland to Rangiwahia'), 'Ngaruawahia to Putaruru', '2016-09-02', '2016-09-02', @returnedRows);
CALL createItinerary(RETURNTRIPIDENTIFIER('101594866096129072852', 'Auckland to Rangiwahia'), 'Putaruru to Wairakei', '2016-09-03', '2016-09-03', @returnedRows);
CALL createItinerary(RETURNTRIPIDENTIFIER('101594866096129072852', 'Auckland to Rangiwahia'), 'Wairakei to Waiouru', '2016-09-04', '2016-09-04', @returnedRows);
CALL createItinerary(RETURNTRIPIDENTIFIER('101594866096129072852', 'Auckland to Rangiwahia'), 'Waiouru to Rangiwahia', '2016-09-05', '2016-09-05', @returnedRows);
CALL createItinerary(RETURNTRIPIDENTIFIER('101594866096129072852', 'Milan to Barcelona'), 'Fontanile Basin to Cao Basin', '2016-09-05', '2016-09-05', @returnedRows);
CALL createItinerary(RETURNTRIPIDENTIFIER('101594866096129072852', 'Milan to Barcelona'), 'Cao Basin to Genoa', '2016-09-06', '2016-09-06', @returnedRows);
CALL createItinerary(RETURNTRIPIDENTIFIER('101594866096129072852', 'Milan to Barcelona'), 'Genoa to Draguignan', '2016-09-07', '2016-09-07', @returnedRows);
CALL createItinerary(RETURNTRIPIDENTIFIER('101594866096129072852', 'Milan to Barcelona'), 'Draguignan to Aix en Provence', '2016-09-08', '2016-09-08', @returnedRows);
CALL createItinerary(RETURNTRIPIDENTIFIER('101594866096129072852', 'Milan to Barcelona'), 'Aix en Provence to Nimes', '2016-09-09', '2016-09-09', @returnedRows);
CALL createItinerary(RETURNTRIPIDENTIFIER('101594866096129072852', 'Milan to Barcelona'), 'Nimes to Barcelona', '2016-09-10', '2016-09-10', @returnedRows);
SELECT @returnedRows;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*RETRIEVE TRIPS*/
CALL listTrips('101594866096129072852', @tripNames, @itinerariesCount, @startDates, @finishDates, @tripsCount);
SELECT @tripNames, @itinerariesCount, @startDates, @finishDates, @tripsCount;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*RETRIEVE ITINERARIES*/
CALL listItineraries('101594866096129072852', '*', @tripNames, @itineraryNames, @startDates, @finishDates, @itineraryPolylines, @itinerariesCount);
CALL listItineraries('101594866096129072852', RETURNTRIPIDENTIFIER('101594866096129072852', 'Auckland to Rangiwahia'), @tripNames, @itineraryNames, @startDates, @finishDates, @itineraryPolylines, @itinerariesCount);
CALL listItineraries('101594866096129072852', RETURNTRIPIDENTIFIER('101594866096129072852', 'Milan to Barcelona'), @tripNames, @itineraryNames, @startDates, @finishDates, @itineraryPolylines, @itinerariesCount);
SELECT @itineraryNames, @tripNames, @startDates, @finishDates, @itineraryPolylines, @itinerariesCount;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*EDIT ITINERARY POLYLINE OF SPECIFIED ITINERARY*/
CALL updateItineraryPolyline(RETURNITINERARYIDENTIFIER('101594866096129072852', 'Mombasa to Namibia', 'Mombasa to Diani Beach'), 'dxxWcvdqF`u@mErg@|gAdo@uHvh@mMp~OpoMnjGijBzgB~tBv}GfsDvJihC~aHhhC', @returnedRows);
CALL updateItineraryPolyline(RETURNITINERARYIDENTIFIER('101594866096129072852', 'Milan to Barcelona', 'Fontanile Basin to Cao Basin'), 'sesuGocou@iO`NaMg`@_NqY??', @returnedRows);
CALL updateItineraryPolyline(RETURNITINERARYIDENTIFIER('101594866096129072852', 'Milan to Barcelona', 'Cao Basin to Genoa'), '', @returnedRows);
SELECT @returnedRows;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*EDIT CHECK-IN POLYLINE OF SPECIFIED ITINERARY*/
CALL updateCheckInPolyline(RETURNITINERARYIDENTIFIER('101594866096129072852', 'Mombasa to Namibia', 'Mombasa to Diani Beach'), 'zbtWycupFweBc`EzeCavB`qH_aDd|WjoLbfF`l@n~D`{@', @returnedRows);
CALL updateCheckInPolyline(RETURNITINERARYIDENTIFIER('101594866096129072852', 'Milan to Barcelona', 'Fontanile Basin to Cao Basin'), 'ygruGocru@y\\`cB`e@kxGg~AhGw{AzkBffBzgB', @returnedRows);
CALL updateCheckInPolyline(RETURNITINERARYIDENTIFIER('101594866096129072852', 'Milan to Barcelona', 'Cao Basin to Genoa'), '', @returnedRows);
SELECT @returnedRows;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*EDIT ABSOLUTELY NO TRIP INFORMATION*/
CALL updateTripDetails('101594866096129072852', RETURNTRIPIDENTIFIER('101594866096129072852', 'Mombasa to Namibia'), 'Mombasa to Namibia', '2016-08-25', '2017-08-25', @returnedRows);
CALL updateTripDetails('101594866096129072852', RETURNTRIPIDENTIFIER('101594866096129072852', 'Auckland to Rangiwahia'), 'Auckland to Rangiwahia', '2016-08-25', '2016-08-25', @returnedRows);

/*EDIT TRIP DATES*/
CALL updateTripDetails('101594866096129072852', RETURNTRIPIDENTIFIER('101594866096129072852', 'Mombasa to Namibia'), 'Mombasa to Namibia', '2016-08-26', '2017-08-26', @returnedRows);
CALL updateTripDetails('101594866096129072852', RETURNTRIPIDENTIFIER('101594866096129072852', 'Auckland to Rangiwahia'), 'Auckland to Rangiwahia', '2016-08-26', '2017-08-26', @returnedRows);

/*EDIT TRIP NAME*/
CALL updateTripDetails('101594866096129072852', RETURNTRIPIDENTIFIER('101594866096129072852', 'Mombasa to Namibia'), 'Mombasa to Windhoek', '2016-08-26', '2017-08-26', @returnedRows);
CALL updateTripDetails('101594866096129072852', RETURNTRIPIDENTIFIER('101594866096129072852', 'Auckland to Rangiwahia'), 'Auckland to Manawatu', '2016-08-26', '2017-08-26', @returnedRows);
SELECT @returnedRows;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*EDIT ABSOLUTELY NO ITINERARY INFORMATION*/
CALL updateItineraryDetails('101594866096129072852', RETURNITINERARYIDENTIFIER('101594866096129072852', 'Milan to Barcelona', 'Fontanile Basin to Cao Basin'), 'Fontanile Basin to Cao Basin', '2016-09-05', '2016-09-05', @returnedRows);
CALL updateItineraryDetails('101594866096129072852', RETURNITINERARYIDENTIFIER('101594866096129072852', 'Milan to Barcelona', 'Cao Basin to Genoa'), 'Cao Basin to Genoa', '2016-09-06', '2016-09-06', @returnedRows);
CALL updateItineraryDetails('101594866096129072852', RETURNITINERARYIDENTIFIER('101594866096129072852', 'Milan to Barcelona', 'Genoa to Draguignan'), 'Genoa to Draguignan', '2016-09-07', '2016-09-07', @returnedRows);

/*EDIT ITINERARY DATES*/
CALL updateItineraryDetails('101594866096129072852', RETURNITINERARYIDENTIFIER('101594866096129072852', 'Milan to Barcelona', 'Fontanile Basin to Cao Basin'), 'Fontanile Basin to Cao Basin', '2016-09-06', '2016-09-06', @returnedRows);
CALL updateItineraryDetails('101594866096129072852', RETURNITINERARYIDENTIFIER('101594866096129072852', 'Milan to Barcelona', 'Cao Basin to Genoa'), 'Cao Basin to Genoa', '2016-09-07', '2016-09-07', @returnedRows);
CALL updateItineraryDetails('101594866096129072852', RETURNITINERARYIDENTIFIER('101594866096129072852', 'Milan to Barcelona', 'Genoa to Draguignan'), 'Genoa to Draguignan', '2016-09-08', '2016-09-08', @returnedRows);

/*EDIT ITINERARY NAME*/
CALL updateItineraryDetails('101594866096129072852', RETURNITINERARYIDENTIFIER('101594866096129072852', 'Milan to Barcelona', 'Fontanile Basin to Cao Basin'), 'Pinewood Basins', '2016-09-06', '2016-09-06', @returnedRows);
CALL updateItineraryDetails('101594866096129072852', RETURNITINERARYIDENTIFIER('101594866096129072852', 'Milan to Barcelona', 'Cao Basin to Genoa'), 'Pinewood to Shoreline', '2016-09-07', '2016-09-07', @returnedRows);
CALL updateItineraryDetails('101594866096129072852', RETURNITINERARYIDENTIFIER('101594866096129072852', 'Milan to Barcelona', 'Genoa to Draguignan'), 'Liguria to Provence', '2016-09-08', '2016-09-08', @returnedRows);
SELECT @returnedRows;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*DELETE SPECIFIED TRIP*/
CALL deleteTrip(RETURNTRIPIDENTIFIER('101594866096129072852', 'Auckland to Manawatu'), @returnedRows);
CALL deleteTrip(RETURNTRIPIDENTIFIER('101594866096129072852', 'Mombasa to Windhoek'), @returnedRows);
CALL deleteTrip(RETURNTRIPIDENTIFIER('101594866096129072852', 'Milan to Barcelona'), @returnedRows);
SELECT @returnedRows;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*DELETE SPECIFIED ITINERARY*/
CALL deleteItinerary(RETURNITINERARYIDENTIFIER('101594866096129072852', 'Auckland to Manawatu', 'Auckland to Meremere'), @returnedRows);
CALL deleteItinerary(RETURNITINERARYIDENTIFIER('101594866096129072852', 'Mombasa to Windhoek', 'Mombasa to Diani Beach'), @returnedRows);
CALL deleteItinerary(RETURNITINERARYIDENTIFIER('101594866096129072852', 'Milan to Barcelona', 'Pinewood Basins'), @returnedRows);
SELECT @returnedRows;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*ADD FOLLOWER TO SPECIFIED TRIP*/
CALL addFollower('101594866096129072852', 'raisins@sunsweet.com', RETURNTRIPIDENTIFIER('101594866096129072852', 'Auckland to Manawatu'), @returnedRows);
CALL addFollower('101594866096129072852', 'sultanas@sunsweet.com', RETURNTRIPIDENTIFIER('101594866096129072852', 'Auckland to Manawatu'), @returnedRows);
CALL addFollower('101594866096129072852', 'prunes@sunsweet.com', RETURNTRIPIDENTIFIER('101594866096129072852', 'Auckland to Manawatu'), @returnedRows);

CALL addFollower('101594866096129072852', 'raisins@sunsweet.com', RETURNTRIPIDENTIFIER('101594866096129072852', 'Mombasa to Windhoek'), @returnedRows);
CALL addFollower('101594866096129072852', 'sultanas@sunsweet.com', RETURNTRIPIDENTIFIER('101594866096129072852', 'Mombasa to Windhoek'), @returnedRows);
CALL addFollower('101594866096129072852', 'prunes@sunsweet.com', RETURNTRIPIDENTIFIER('101594866096129072852', 'Mombasa to Windhoek'), @returnedRows);

CALL addFollower('101594866096129072852', 'raisins@sunsweet.com', RETURNTRIPIDENTIFIER('101594866096129072852', 'Milan to Barcelona'), @returnedRows);
CALL addFollower('101594866096129072852', 'sultanas@sunsweet.com', RETURNTRIPIDENTIFIER('101594866096129072852', 'Milan to Barcelona'), @returnedRows);
CALL addFollower('101594866096129072852', 'prunes@sunsweet.com', RETURNTRIPIDENTIFIER('101594866096129072852', 'Milan to Barcelona'), @returnedRows);
SELECT @returnedRows;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*REMOVE FOLLOWER FROM SPECIFIED TRIP*/
CALL deleteFollower('101594866096129072852', 'raisins@sunsweet.com', RETURNTRIPIDENTIFIER('101594866096129072852', 'Auckland to Manawatu'), @returnedRows);
CALL deleteFollower('101594866096129072852', 'sultanas@sunsweet.com', RETURNTRIPIDENTIFIER('101594866096129072852', 'Auckland to Manawatu'), @returnedRows);
CALL deleteFollower('101594866096129072852', 'prunes@sunsweet.com', RETURNTRIPIDENTIFIER('101594866096129072852', 'Auckland to Manawatu'), @returnedRows);

CALL deleteFollower('101594866096129072852', 'raisins@sunsweet.com', RETURNTRIPIDENTIFIER('101594866096129072852', 'Mombasa to Windhoek'), @returnedRows);
CALL deleteFollower('101594866096129072852', 'sultanas@sunsweet.com', RETURNTRIPIDENTIFIER('101594866096129072852', 'Mombasa to Windhoek'), @returnedRows);
CALL deleteFollower('101594866096129072852', 'prunes@sunsweet.com', RETURNTRIPIDENTIFIER('101594866096129072852', 'Mombasa to Windhoek'), @returnedRows);

CALL deleteFollower('101594866096129072852', 'raisins@sunsweet.com', RETURNTRIPIDENTIFIER('101594866096129072852', 'Milan to Barcelona'), @returnedRows);
CALL deleteFollower('101594866096129072852', 'sultanas@sunsweet.com', RETURNTRIPIDENTIFIER('101594866096129072852', 'Milan to Barcelona'), @returnedRows);
CALL deleteFollower('101594866096129072852', 'prunes@sunsweet.com', RETURNTRIPIDENTIFIER('101594866096129072852', 'Milan to Barcelona'), @returnedRows);
SELECT @returnedRows;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*UNFOLLOW SPECIFIED TRIP*/
CALL unfollowTrip('raisins@sunsweet.com', RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-26', '2017-08-26', 'Mombasa to Windhoek', 'raisins@sunsweet.com', 'Kirth', 'Gersen'), @returnedRows);
CALL unfollowTrip('sultanas@sunsweet.com', RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-26', '2017-08-26', 'Mombasa to Windhoek', 'sultanas@sunsweet.com', 'Kirth', 'Gersen'), @returnedRows);
CALL unfollowTrip('prunes@sunsweet.com', RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-26', '2017-08-26', 'Mombasa to Windhoek', 'prunes@sunsweet.com', 'Kirth', 'Gersen'), @returnedRows);

CALL unfollowTrip('raisins@sunsweet.com', RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-26', '2017-08-26', 'Auckland to Manawatu', 'raisins@sunsweet.com', 'Kirth', 'Gersen'), @returnedRows);
CALL unfollowTrip('sultanas@sunsweet.com', RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-26', '2017-08-26', 'Auckland to Manawatu', 'sultanas@sunsweet.com', 'Kirth', 'Gersen'), @returnedRows);
CALL unfollowTrip('prunes@sunsweet.com', RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-26', '2017-08-26', 'Auckland to Manawatu', 'prunes@sunsweet.com', 'Kirth', 'Gersen'), @returnedRows);

CALL unfollowTrip('raisins@sunsweet.com', RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-25', '2016-08-26', 'Milan to Barcelona', 'raisins@sunsweet.com', 'Kirth', 'Gersen'), @returnedRows);
CALL unfollowTrip('sultanas@sunsweet.com', RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-25', '2016-08-26', 'Milan to Barcelona', 'sultanas@sunsweet.com', 'Kirth', 'Gersen'), @returnedRows);
CALL unfollowTrip('prunes@sunsweet.com', RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-25', '2016-08-26', 'Milan to Barcelona', 'prunes@sunsweet.com', 'Kirth', 'Gersen'), @returnedRows);
SELECT @returnedRows;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*LIST FOLLOWERS ASSOCIATED TO THAT SPECIFIC ACCOUNT*/
CALL listFollowers('101594866096129072852', @tripNames, @emailAddresses, @emailNumber);
SELECT @tripNames, @emailAddresses, @emailNumber;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*LIST TRIPS ASSOCIATED TO THAT SPECIFIC EMAIL ADDRESS*/
CALL listFollowedTrips('raisins@sunsweet.com', @tripNames, @travellerFirstNames, @travellerLastNames, @startDates, @finishDates, @tripNumber);
CALL listFollowedTrips('sultanas@sunsweet.com', @tripNames, @travellerFirstNames, @travellerLastNames, @startDates, @finishDates, @tripNumber);
CALL listFollowedTrips('prunes@sunsweet.com', @tripNames, @travellerFirstNames, @travellerLastNames, @startDates, @finishDates, @tripNumber);
SELECT @tripNames, @travellerFirstNames, @travellerLastNames, @startDates, @finishDates, @tripNumber;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*LIST ITINERARIES ASSOCIATED TO THAT SPECIFIC FOLLOWED TRIP*/
CALL listFollowedItineraries('raisins@sunsweet.com', RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-26', '2017-08-26', 'Mombasa to Windhoek', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), @itineraryNames, @tripNames, @startDates, @finishDates, @polylines, @itineraryNumber);
CALL listFollowedItineraries('raisins@sunsweet.com', RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-26', '2017-08-26', 'Auckland to Manawatu', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), @itineraryNames, @tripNames, @startDates, @finishDates, @polylines, @itineraryNumber);
CALL listFollowedItineraries('raisins@sunsweet.com', RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-25', '2016-08-26', 'Milan to Barcelona', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), @itineraryNames, @tripNames, @startDates, @finishDates, @polylines, @itineraryNumber);
SELECT @itineraryNames, @tripNames, @startDates, @finishDates, @polylines, @itineraryNumber;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*RETRIEVE ITINERARY POLYLINE OF SPECIFIED ITINERARY*/
CALL selectItineraryPolyline('101594866096129072852', 'Mombasa to Windhoek', 'Mombasa to Diani Beach', @itineraryPolyline);
CALL selectItineraryPolyline('101594866096129072852', 'Milan to Barcelona', 'Pinewood Basins', @itineraryPolyline);
CALL selectItineraryPolyline('101594866096129072852', 'Milan to Barcelona', 'Pinewood to Shoreline', @itineraryPolyline);
SELECT @itineraryPolyline;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*RETRIEVE CHECK-IN POLYLINE OF SPECIFIED ITINERARY*/
CALL selectCheckInPolyline('101594866096129072852', 'Mombasa to Windhoek', 'Mombasa to Diani Beach', @checkInPolyline);
CALL selectCheckInPolyline('101594866096129072852', 'Milan to Barcelona', 'Pinewood Basins', @checkInPolyline);
CALL selectCheckInPolyline('101594866096129072852', 'Milan to Barcelona', 'Pinewood to Shoreline', @checkInPolyline);
SELECT @checkInPolyline;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*RETRIEVE ITINERARY POLYLINE OF SPECIFIED FOLLOWED ITINERARY*/
CALL selectFollowedItineraryPolyline('raisins@sunsweet.com', RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-26', '2017-08-26', 'Mombasa to Windhoek', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), 'Mombasa to Diani Beach', @followedItineraryPolyline);
CALL selectFollowedItineraryPolyline('raisins@sunsweet.com', RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-26', '2017-08-26', 'Auckland to Manawatu', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), 'Waiouru to Rangiwahia', @followedItineraryPolyline);
CALL selectFollowedItineraryPolyline('raisins@sunsweet.com', RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-25', '2016-08-26', 'Milan to Barcelona', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), 'Pinewood to Shoreline', @followedItineraryPolyline);
SELECT @followedItineraryPolyline;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*RETRIEVE CHECK-IN POLYLINE OF SPECIFIED FOLLOWED ITINERARY*/
CALL selectFollowedCheckInPolyline('raisins@sunsweet.com', RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-26', '2017-08-26', 'Mombasa to Windhoek', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), 'Mombasa to Diani Beach', @followedCheckInPolyline);
CALL selectFollowedCheckInPolyline('raisins@sunsweet.com', RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-26', '2017-08-26', 'Auckland to Manawatu', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), 'Waiouru to Rangiwahia', @followedCheckInPolyline);
CALL selectFollowedCheckInPolyline('raisins@sunsweet.com', RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-25', '2016-08-26', 'Milan to Barcelona', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), 'Pinewood to Shoreline', @followedCheckInPolyline);
SELECT @followedCheckInPolyline;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*RETRIEVE RECOMMENDATION POLYLINE OF SPECIFIED ITINERARY*/
CALL selectRecommendationPolyline(RETURNFOLLOWEDITINERARYIDENTIFIER('2016-08-25', '2016-08-26', 'Mombasa to Windhoek', 'Mombasa to Diani Beach', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), @polylineString, @polylineVersion, @polylinesFound);
CALL selectRecommendationPolyline(RETURNFOLLOWEDITINERARYIDENTIFIER('2016-09-06', '2016-09-06', 'Milan to Barcelona', 'Pinewood Basins', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), @polylineString, @polylineVersion, @polylinesFound);
CALL selectRecommendationPolyline(RETURNFOLLOWEDITINERARYIDENTIFIER('2016-09-07', '2016-09-07', 'Milan to Barcelona', 'Pinewood to Shoreline', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), @polylineString, @polylineVersion, @polylinesFound);
SELECT @polylineString, @polylineVersion, @polylinesFound;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*EDIT RECOMMENDATION POLYLINE OF SPECIFIED ITINERARY*/
CALL updateRecommendationPolyline(RETURNFOLLOWEDITINERARYIDENTIFIER('2016-08-25', '2016-08-26', 'Mombasa to Windhoek', 'Mombasa to Diani Beach', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), 'hn{Wor_qFbnUrqG~mUtqG|gZxiK', 0, @returnedRows);
CALL updateRecommendationPolyline(RETURNFOLLOWEDITINERARYIDENTIFIER('2016-09-06', '2016-09-06', 'Milan to Barcelona', 'Pinewood Basins', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), '}stuGe|pu@t`@af@wGx`@hWsScIpy@dCdTpBxE', 0, @returnedRows);
CALL updateRecommendationPolyline(RETURNFOLLOWEDITINERARYIDENTIFIER('2016-09-07', '2016-09-07', 'Milan to Barcelona', 'Pinewood to Shoreline', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), '', 0, @returnedRows);

/*ATTEMPT TO SUBMIT INCORRECT INFORMATION*/
CALL updateRecommendationPolyline(RETURNFOLLOWEDITINERARYIDENTIFIER('2016-08-26', '2017-08-26', 'Mombasa to Windhoek', 'Mombasa to Diani Beach', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), 'hn{Wor_qFbnUrqG~mUtqG|gZxiK', 0, @returnedRows);
CALL updateRecommendationPolyline(RETURNFOLLOWEDITINERARYIDENTIFIER('2016-08-26', '2017-08-26', 'Milan to Barcelona', 'Pinewood Basins', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), '}stuGe|pu@t`@af@wGx`@hWsScIpy@dCdTpBxE', 0, @returnedRows);
CALL updateRecommendationPolyline(RETURNFOLLOWEDITINERARYIDENTIFIER('2016-08-26', '2017-08-26', 'Milan to Barcelona', 'Pinewood to Shoreline', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), '', 0, @returnedRows);

/*ATTEMPT UPDATE WITH A NEW VERSION NUMBER*/
CALL updateRecommendationPolyline(RETURNFOLLOWEDITINERARYIDENTIFIER('2016-08-25', '2016-08-26', 'Mombasa to Windhoek', 'Mombasa to Diani Beach', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), 'bnyW_mdqFfie@nlNvuMvhEbtSjdE', 1, @returnedRows);
CALL updateRecommendationPolyline(RETURNFOLLOWEDITINERARYIDENTIFIER('2016-09-06', '2016-09-06', 'Milan to Barcelona', 'Pinewood Basins', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), '}stuGe|pu@t`@af@wGx`@hWsScIpy@{BhVjK}Fn@tDt@pJ_EdBsAyJsD|D', 1, @returnedRows);
CALL updateRecommendationPolyline(RETURNFOLLOWEDITINERARYIDENTIFIER('2016-09-07', '2016-09-07', 'Milan to Barcelona', 'Pinewood to Shoreline', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), 'efsuGg`ou@wNnJ`Mfv@rPrw@nqC_\hjDq[xbQa}CtxFpzIprKc`E|oPfaKnpqAb{@nr~Ao|S', 1, @returnedRows);
SELECT @returnedRows;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*RETRIEVE RECOMMENDATION POLYLINE OF SPECIFIED ITINERARY*/
CALL selectRecommendationPolyline(RETURNFOLLOWEDITINERARYIDENTIFIER('2016-08-25', '2016-08-26', 'Mombasa to Windhoek', 'Mombasa to Diani Beach', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), @polylineString, @polylineVersion, @polylinesFound);
CALL selectRecommendationPolyline(RETURNFOLLOWEDITINERARYIDENTIFIER('2016-09-06', '2016-09-06', 'Milan to Barcelona', 'Pinewood Basins', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), @polylineString, @polylineVersion, @polylinesFound);
CALL selectRecommendationPolyline(RETURNFOLLOWEDITINERARYIDENTIFIER('2016-09-07', '2016-09-07', 'Milan to Barcelona', 'Pinewood to Shoreline', 'raisins@sunsweet.com', 'Dirk', 'Pitt'), @polylineString, @polylineVersion, @polylinesFound);
SELECT @polylineString, @polylineVersion, @polylinesFound;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
