--#SET TERMINATOR @

SET serveroutput ON @

CREATE PROCEDURE COMPARISON (IN VAL1 INT, IN VAL2 INT)
 BEGIN
  IF (VAL1 < VAL2) THEN
    CALL DBMS_OUTPUT.PUT_LINE(VAL1 || ' less than ' || VAL2);
  ELSEIF (VAL1 = VAL2) THEN
    CALL DBMS_OUTPUT.PUT_LINE(VAL1 || ' equal to ' || VAL2);
  ELSEIF (VAL1 > VAL2) THEN
    CALL DBMS_OUTPUT.PUT_LINE(VAL1 || ' greater than ' || VAL2);
  END IF;
 END @
CALL COMPARISON(1, 2) @
CALL COMPARISON(2, 2) @
CALL COMPARISON(2, 1) @
