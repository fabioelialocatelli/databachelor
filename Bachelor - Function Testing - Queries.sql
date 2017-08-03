/**
* @author FABIO ELIA LOCATELLI
* @studentID 2143701
* @revisionDate 11/10/2016
* @purpose QUERY FUNCTIONS TEST CASES COLLECTION
*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

USE `EnRoute`;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

SELECT RETURNTRIPIDENTIFIER('101594866096129072852', 'Auckland to Manawatu');
SELECT RETURNTRIPIDENTIFIER('101594866096129072852', 'Mombasa to Windhoek');
SELECT RETURNTRIPIDENTIFIER('101594866096129072852', 'Milan to Barcelona');

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

SELECT RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-26', '2017-08-26', 'Mombasa to Windhoek', 'raisins@sunsweet.com', 'Dirk', 'Pitt');
SELECT RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-26', '2017-08-26', 'Mombasa to Windhoek', 'sultanas@sunsweet.com', 'Dirk', 'Pitt');
SELECT RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-26', '2017-08-26', 'Mombasa to Windhoek', 'prunes@sunsweet.com', 'Dirk', 'Pitt');

SELECT RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-26', '2017-08-26', 'Auckland to Manawatu', 'raisins@sunsweet.com', 'Dirk', 'Pitt');
SELECT RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-26', '2017-08-26', 'Auckland to Manawatu', 'sultanas@sunsweet.com', 'Dirk', 'Pitt');
SELECT RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-26', '2017-08-26', 'Auckland to Manawatu', 'prunes@sunsweet.com', 'Dirk', 'Pitt');

SELECT RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-25', '2016-08-26', 'Milan to Barcelona', 'raisins@sunsweet.com', 'Dirk', 'Pitt');
SELECT RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-25', '2016-08-26', 'Milan to Barcelona', 'sultanas@sunsweet.com', 'Dirk', 'Pitt');
SELECT RETURNFOLLOWEDTRIPIDENTIFIER('2016-08-25', '2016-08-26', 'Milan to Barcelona', 'prunes@sunsweet.com', 'Dirk', 'Pitt');

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

SELECT RETURNITINERARYIDENTIFIER('101594866096129072852', 'Mombasa to Windhoek', 'Mombasa to Diani Beach');
SELECT RETURNITINERARYIDENTIFIER('101594866096129072852', 'Mombasa to Windhoek', 'Diani Beach to Msambweni');
SELECT RETURNITINERARYIDENTIFIER('101594866096129072852', 'Mombasa to Windhoek', 'Msambweni to Lunga-Lunga');

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

SELECT RETURNTRIPNAME('101594866096129072852', RETURNTRIPIDENTIFIER('101594866096129072852', 'Auckland to Manawatu'));
SELECT RETURNTRIPNAME('101594866096129072852', RETURNTRIPIDENTIFIER('101594866096129072852', 'Mombasa to Windhoek'));
SELECT RETURNTRIPNAME('101594866096129072852', RETURNTRIPIDENTIFIER('101594866096129072852', 'Milan to Barcelona'));

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
