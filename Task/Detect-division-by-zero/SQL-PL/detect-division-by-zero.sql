--#SET TERMINATOR @

SET SERVEROUTPUT ON@

CREATE OR REPLACE FUNCTION DIVISION(
  IN NUMERATOR DECIMAL(5, 3),
  IN DENOMINATOR DECIMAL(5, 3)
 ) RETURNS SMALLINT
 BEGIN
  DECLARE RET SMALLINT DEFAULT 1;
  DECLARE TMP DECIMAL(5, 3);
  DECLARE CONTINUE HANDLER FOR SQLSTATE '22012'
    SET RET = 1;

  SET RET = 0;
  SET TMP = NUMERATOR / DENOMINATOR;
  RETURN RET;
 END @

VALUES DIVISION(10, 2)@
VALUES DIVISION(10, 3)@
VALUES DIVISION(10, 0)@
