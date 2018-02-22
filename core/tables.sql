/**
* @author FABIO ELIA LOCATELLI
* @studentID 2143701
* @revisionDate 11/10/2016
* @purpose DATABASE AND TABLES GENERATION
*--------------------------------------------------------------------------*/

/*DATABASE CREATION AND ENCODING SPECIFICATION*/
DROP SCHEMA IF EXISTS `EnRoute`;
CREATE SCHEMA IF NOT EXISTS `EnRoute` DEFAULT CHARACTER SET utf8 ;
USE `EnRoute`;

/*-------------------------------------------------------------------------*/

/*USER DATA ENTITY CREATION*/
DROP TABLE IF EXISTS `EnRoute`.`User`;
CREATE TABLE IF NOT EXISTS `EnRoute`.`User` (
    `userID` VARCHAR(45) NOT NULL,
    `emailAddress` VARCHAR(45) NULL,
    `firstName` VARCHAR(45) NULL,
    `lastName` VARCHAR(45) NULL,
    PRIMARY KEY (`userID`)
)  ENGINE=INNODB;

/*-------------------------------------------------------------------------*/

/*TRAVELLER DATA ENTITY CREATION*/
DROP TABLE IF EXISTS `EnRoute`.`Traveller`;
CREATE TABLE IF NOT EXISTS `EnRoute`.`Traveller` (
    `travellerID` VARCHAR(45) NOT NULL,
    `userID` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`travellerID` , `userID`),
    INDEX `travellerIndex` (`userID` ASC),
    CONSTRAINT `travellerUserFK` FOREIGN KEY (`userID`)
        REFERENCES `EnRoute`.`User` (`userID`)
        ON DELETE CASCADE ON UPDATE CASCADE
)  ENGINE=INNODB;

/*-------------------------------------------------------------------------*/

/*TRIP DATA ENTITY CREATION*/
DROP TABLE IF EXISTS `EnRoute`.`Trip`;
CREATE TABLE IF NOT EXISTS `EnRoute`.`Trip` (
    `tripID` VARCHAR(45) NOT NULL,
    `tripName` VARCHAR(150) NULL,
    `startDate` DATE NULL,
    `finishDate` DATE NULL,
    `travellerID` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`tripID` , `travellerID`),
    INDEX `tripIndex` (`travellerID` ASC),
    CONSTRAINT `tripTravellerFK` FOREIGN KEY (`travellerID`)
        REFERENCES `EnRoute`.`Traveller` (`travellerID`)
        ON DELETE CASCADE ON UPDATE CASCADE
)  ENGINE=INNODB;

/*-------------------------------------------------------------------------*/

/*FOLLOWER DATA ENTITY CREATION*/
DROP TABLE IF EXISTS `EnRoute`.`Follower`;
CREATE TABLE IF NOT EXISTS `EnRoute`.`Follower` (
    `followerID` VARCHAR(45) NOT NULL,
    `userID` VARCHAR(45) NOT NULL,
    `tripID` VARCHAR(45) NOT NULL,
    `travellerID` VARCHAR(45) NOT NULL,
    `tripName` VARCHAR(45),
    `travellerFirstName` VARCHAR(45),
    `travellerLastName` VARCHAR(45),
    `emailAddress` VARCHAR(45),
    PRIMARY KEY (`followerID` , `userID` , `tripID` , `travellerID`),
    INDEX `followerIndex_1` (`userID` ASC),
    INDEX `followerIndex_2` (`tripID` ASC),
    INDEX `followerIndex_3` (`travellerID` ASC),
    CONSTRAINT `followerUserFK` FOREIGN KEY (`userID`)
        REFERENCES `EnRoute`.`User` (`userID`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `followerTripFK` FOREIGN KEY (`tripID`)
        REFERENCES `EnRoute`.`Trip` (`tripID`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `followerTravellerFK` FOREIGN KEY (`travellerID`)
        REFERENCES `EnRoute`.`Traveller` (`travellerID`)
        ON DELETE CASCADE ON UPDATE CASCADE
)  ENGINE=INNODB;

/*-------------------------------------------------------------------------*/

/*ITINERARY DATA ENTITY CREATION*/
DROP TABLE IF EXISTS `EnRoute`.`Itinerary`;
CREATE TABLE IF NOT EXISTS `EnRoute`.`Itinerary` (
    `itineraryID` VARCHAR(75) NOT NULL,
    `polyline` LONGTEXT NULL,
    `itineraryName` VARCHAR(150) NULL,
    `startDate` DATE NULL,
    `finishDate` DATE NULL,
    `tripID` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`itineraryID` , `tripID`),
    INDEX `itineraryIndex` (`tripID` ASC),
    CONSTRAINT `itineraryTripFK` FOREIGN KEY (`tripID`)
        REFERENCES `EnRoute`.`Trip` (`tripID`)
        ON DELETE CASCADE ON UPDATE CASCADE
)  ENGINE=INNODB;

/*-------------------------------------------------------------------------*/

/*CHECK-IN DATA ENTITY CREATION*/
DROP TABLE IF EXISTS `EnRoute`.`CheckIn`;
CREATE TABLE IF NOT EXISTS `EnRoute`.`CheckIn` (
    `listID` VARCHAR(95) NOT NULL,
    `polyline` LONGTEXT NULL,
    `itineraryID` VARCHAR(75) NOT NULL,
    PRIMARY KEY (`listID` , `itineraryID`),
    INDEX `checkInIndex` (`itineraryID` ASC),
    CONSTRAINT `checkInItineraryFK` FOREIGN KEY (`itineraryID`)
        REFERENCES `EnRoute`.`Itinerary` (`itineraryID`)
        ON DELETE CASCADE ON UPDATE CASCADE
)  ENGINE=INNODB;

/*-------------------------------------------------------------------------*/

/*RECOMMENDATION DATA ENTITY CREATION*/
DROP TABLE IF EXISTS `EnRoute`.`Recommendation`;
CREATE TABLE IF NOT EXISTS `EnRoute`.`Recommendation` (
    `listID` VARCHAR(95) NOT NULL,
    `polyline` LONGTEXT NULL,
    `version` INT,
    `itineraryID` VARCHAR(75) NOT NULL,
    PRIMARY KEY (`listID` , `itineraryID`),
    INDEX `recommendationIndex` (`itineraryID` ASC),
    CONSTRAINT `recommendationItineraryFK` FOREIGN KEY (`itineraryID`)
        REFERENCES `EnRoute`.`Itinerary` (`itineraryID`)
        ON DELETE CASCADE ON UPDATE CASCADE
)  ENGINE=INNODB;

/*-------------------------------------------------------------------------*/
