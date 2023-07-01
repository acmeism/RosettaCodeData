--#SET TERMINATOR @

SET SERVEROUTPUT ON @

CREATE OR REPLACE FUNCTION VALIDATE_ISIN (
  IN IDENTIFIER VARCHAR(12)
 ) RETURNS SMALLINT
 -- ) RETURNS BOOLEAN
 BEGIN
  DECLARE CHECKSUM_FUNC CHAR(1);
  DECLARE CONVERTED VARCHAR(24);
  DECLARE I SMALLINT;
  DECLARE LENGTH SMALLINT;
  DECLARE RET SMALLINT DEFAULT 1;
  --DECLARE RET BOOLEAN DEFAULT FALSE;
  DECLARE CHAR_AT CHAR(1);
  DECLARE INVALID_CHAR CONDITION FOR SQLSTATE 'ISIN1';

  SET CHAR_AT = SUBSTR(IDENTIFIER, 1, 1);
  IF (ASCII(CHAR_AT) < 65 OR 90 < ASCII(CHAR_AT)) THEN
   SIGNAL INVALID_CHAR SET MESSAGE_TEXT = 'Country code with invalid characters';
  END IF;
  SET CHAR_AT = SUBSTR(IDENTIFIER, 2, 1);
  IF (ASCII(CHAR_AT) < 65 OR 90 < ASCII(CHAR_AT)) THEN
   SIGNAL INVALID_CHAR SET MESSAGE_TEXT = 'Country code with invalid characters';
  END IF;

  -- Convert letters to numbers.
  SET I = 1;
  SET CONVERTED = '';
  SET LENGTH = LENGTH(IDENTIFIER);
  WHILE (I <= LENGTH) DO
   SET CHAR_AT = SUBSTR(IDENTIFIER, I, 1);
   IF (48 <= ASCII(CHAR_AT) AND ASCII(CHAR_AT) <= 57) THEN
    SET CONVERTED = CONVERTED || CHAR_AT;
   ELSE
    SET CONVERTED = CONVERTED || (ASCII(CHAR_AT) - 55);
   END IF;
   SET I = I + 1;
  END WHILE;

  CALL DBMS_OUTPUT.PUT_LINE(CONVERTED);

  -- This function is implemented in Rosetta code.
  SET CHECKSUM_FUNC = LUHN_TEST(CONVERTED);
  IF (CHECKSUM_FUNC = 0) THEN
   SET RET = 0;
   --SET RET = TRUE;
  END IF;

  RETURN RET;
 END @