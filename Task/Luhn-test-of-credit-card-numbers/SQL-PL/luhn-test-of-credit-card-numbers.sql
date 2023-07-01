--#SET TERMINATOR @

SET SERVEROUTPUT ON @

CREATE OR REPLACE FUNCTION LUHN_TEST (
  IN NUMBER VARCHAR(24)
 ) RETURNS SMALLINT
 --) RETURNS BOOLEAN
 BEGIN
  DECLARE TYPE CARD_NUMBER AS VARCHAR(1) ARRAY [24];
  DECLARE LENGTH SMALLINT;
  DECLARE REVERSE CARD_NUMBER;
  DECLARE I SMALLINT;
  DECLARE POS SMALLINT;
  DECLARE S1 SMALLINT;
  DECLARE S2 SMALLINT;
  DECLARE TEMP SMALLINT;
  DECLARE RET SMALLINT;
  --DECLARE RET BOOLEAN;
  DECLARE INVALID_CHAR CONDITION FOR SQLSTATE 'LUHN1';

  -- Reverse the order of the digits in the number.
  SET LENGTH = LENGTH(NUMBER);
  SET I = 1;
  WHILE (I <= LENGTH) DO
   SET POS = LENGTH - I + 1;
   SET REVERSE[POS] = SUBSTR(NUMBER, I, 1);
   IF (ASCII(REVERSE[POS]) < 48 OR 57 < ASCII(REVERSE[POS])) THEN
    SIGNAL INVALID_CHAR SET MESSAGE_TEXT = 'Invalid character, not a digit';
   END IF;
   SET I = I + 1;
  END WHILE;

  -- Take the first, third, ... and every other odd digit in the reversed digits and sum them to form the partial sum s1
  SET S1 = 0;
  SET I = 1;
  WHILE (I <= LENGTH) DO
   IF (MOD(I, 2) = 1) THEN
    SET S1 = S1 + REVERSE[I];
   END IF;
   -- CALL DBMS_OUTPUT.PUT_LINE('I ' || I || ', S1 ' || S1 || ', val ' || REVERSE[I]);
   SET I = I + 1;
  END WHILE;

  -- Taking the second, fourth ... and every other even digit in the reversed digits:
  SET S2 = 0;
  SET TEMP = 0;
  SET I = 1;
  WHILE (I <= LENGTH) DO
   IF (MOD(I, 2) = 0) THEN
    -- Multiply each digit by two and sum the digits if the answer is greater than nine to form partial sums for the even digits
    SET TEMP = REVERSE[I] * 2;
    IF (TEMP > 9) THEN
     SET TEMP = (TEMP / 10) + (MOD(TEMP, 10));
    END IF;
    -- Sum the partial sums of the even digits to form s2
    SET S2 = S2 + TEMP;
   END IF;
   -- CALL DBMS_OUTPUT.PUT_LINE('I ' || I || ', S2 ' || S2 || ', TEMP ' || TEMP || ' val ' || REVERSE[I]);
   SET I = I + 1;
  END WHILE;

  -- If s1 + s2 ends in zero then the original number is in the form of a valid credit card number as verified by the Luhn test.
  SET RET = 1;
  --SET RET = FALSE;
  SET TEMP = S1 + S2;
  IF (MOD(TEMP, 10) = 0) THEN
   SET RET = 0;
   --SET RET = TRUE;
   CALL DBMS_OUTPUT.PUT_LINE('It is a valid number ' || S1 || '+' || S2 || '=' || TEMP);
  ELSE
   CALL DBMS_OUTPUT.PUT_LINE('It is NOT a valid number ' || S1 || '+' || S2 || '=' || TEMP);
  END IF;
  RETURN RET;
 END
@
