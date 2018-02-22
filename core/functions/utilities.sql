/**
* @author FABIO ELIA LOCATELLI
* @studentID 2143701
* @revisionDate 11/10/2016
* @purpose UTILITY FUNCTIONS COLLECTION
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

USE `EnRoute`;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP FUNCTION IF EXISTS `utilSanitiser`;
DELIMITER //
/*
* FUNCTION NAME   	: 	sanitiseSequence
* INPUT PARAMETERS 	: 	UNSAFE CHARACTER SEQUENCE, UNSAFE ORIGINAL CHARACTER, SAFE REPLACEMENT CHARACTER, ORIGINAL SEPARATOR, REPLACEMENT SEPARATOR
* OUTPUT PARAMETER 	: 	SANITISED CHARACTER SEQUENCE
*/
CREATE FUNCTION `utilSanitiser`(paramUnsafeSequence TEXT, paramOriginalCharacter VARCHAR(45), paramReplacementCharacter VARCHAR(1), paramOriginalSeparator VARCHAR(1), paramReplacementSeparator VARCHAR(1)) RETURNS TEXT READS SQL DATA
SQL SECURITY INVOKER
BEGIN

	DECLARE trimmedSequence TEXT;
	DECLARE safeSequence TEXT;
	DECLARE dangerousKeys VARCHAR(90);
	DECLARE dangerousKey VARCHAR(10);
	DECLARE dangerousKeyPosition INT;
	DECLARE dangerousKeyLength INT;

	SET dangerousKeys := CONCAT_WS('#', '@', '()', 'INSERT', 'UPDATE', 'DELETE', 'EXECUTE', 'DROP', 'DUMPFILE');

	IF INSTR(dangerousKeys, paramOriginalCharacter) >= 1 THEN

		SET dangerousKeyPosition := LOCATE(paramOriginalCharacter, dangerousKeys);
		SET dangerousKeyLength := LENGTH(paramOriginalCharacter);
		SET dangerousKey := SUBSTRING(dangerousKeys, dangerousKeyPosition, dangerousKeyLength);

		SELECT 
		REPLACE(paramUnsafeSequence,
				paramOriginalSeparator,
				paramReplacementSeparator)
		INTO trimmedSequence;
    
		SELECT 
		REPLACE(trimmedSequence,
				dangerousKey,
				paramReplacementCharacter)
		INTO safeSequence;
	END IF;

	RETURN(safeSequence);
    
END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP FUNCTION IF EXISTS `utilTruncate`;
DELIMITER //
/*
* FUNCTION NAME   	: 	truncateString
* INPUT PARAMETERS 	: 	TRUNCATION DIRECTION, TRUNCATION STRING, TRUNCATION CHARACTER NUMBER
* OUTPUT PARAMETER 	: 	TRUNCATED STRING
*/
CREATE FUNCTION `utilTruncate`(paramDirection INT, paramString TEXT, paramCharacterNumber INT) RETURNS TEXT READS SQL DATA
SQL SECURITY INVOKER
BEGIN

	CASE paramDirection
		WHEN 0 THEN
		SET @truncatedString := RIGHT(paramString, paramCharacterNumber);
		WHEN 1 THEN
		SET @truncatedString := LEFT(paramString, paramCharacterNumber);
	END CASE;

	RETURN(@truncatedString);

END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP FUNCTION IF EXISTS `utilSlashes`;
DELIMITER //
/*
* FUNCTION NAME   	: 	escapePolylineSlashes
* INPUT PARAMETER 	: 	REPLACEMENT CHARACTER, UNESCAPED POLYLINE
* OUTPUT PARAMETER 	: 	ESCAPED POLYLINE
*/
CREATE FUNCTION `utilSlashes`(paramReplacementCharacter VARCHAR(1), paramPolyline LONGTEXT) RETURNS TEXT READS SQL DATA
SQL SECURITY INVOKER
BEGIN

	SET @reverseSolidus := '\\';
	SET @escapedPolyline := REPLACE(paramPolyline, @reverseSolidus, paramReplacementCharacter);

	RETURN(@escapedPolyline);

END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP FUNCTION IF EXISTS `utilCase`;
DELIMITER //
/*
* FUNCTION NAME   	: 	escapePolylineSlashes
* INPUT PARAMETER 	: 	CASE OPTION, ORIGINAL STRING
* OUTPUT PARAMETER 	: 	MODIFIED STRING
*/
CREATE FUNCTION `utilCase`(paramCaseOption INT, paramString TEXT) RETURNS TEXT READS SQL DATA
SQL SECURITY INVOKER
BEGIN

	CASE paramCaseOption
		WHEN 0 THEN
		SET @modifiedString := LCASE(paramString);
		WHEN 1 THEN
		SET @modifiedString := UCASE(paramString);
	END CASE;
		
	RETURN(@modifiedString);

END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

DROP FUNCTION IF EXISTS `utilTimestamp`;
DELIMITER //
/*
* FUNCTION NAME   	: 	formatCurrentTimestamp
* INPUT PARAMETER 	: 	TRUNCATION CHARACTER NUMBER
* OUTPUT PARAMETER 	: 	TRUNCATED STRING
*/
CREATE FUNCTION `utilTimestamp`(paramCharacterNumber INT) RETURNS VARCHAR(10) DETERMINISTIC
SQL SECURITY INVOKER
BEGIN

	SET @currentTimestamp := CURRENT_TIMESTAMP();
	SET @formattingPattern := '%X%V%H%I%S';
	SET @formattedTimestamp := DATE_FORMAT(@currentTimestamp, @formattingPattern);
	SET @formattedTimestamp := RIGHT(@formattedTimestamp, paramCharacterNumber);

	RETURN(@formattedTimestamp);

END//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
