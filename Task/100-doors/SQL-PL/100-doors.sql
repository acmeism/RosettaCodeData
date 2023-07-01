--#SET TERMINATOR @

SET SERVEROUTPUT ON @

BEGIN
 DECLARE TYPE DOORS_ARRAY AS BOOLEAN ARRAY [100];
 DECLARE DOORS DOORS_ARRAY;
 DECLARE I SMALLINT;
 DECLARE J SMALLINT;
 DECLARE STATUS CHAR(10);
 DECLARE SIZE SMALLINT DEFAULT 100;

 -- Initializes the array, with all spaces (doors) as false (closed).
 SET I = 1;
 WHILE (I <= SIZE) DO
  SET DOORS[I] = FALSE;
  SET I = I + 1;
 END WHILE;

 -- Processes the doors.
 SET I = 1;
 WHILE (I <= SIZE) DO
  SET J = 1;
  WHILE (J <= SIZE) DO
   IF (MOD(J, I) = 0) THEN
    IF (DOORS[J] = TRUE) THEN
     SET DOORS[J] = FALSE;
    ELSE
     SET DOORS[J] = TRUE;
    END IF;
   END IF;
   SET J = J + 1;
  END WHILE;
  SET I = I + 1;
 END WHILE;

 -- Prints the final status o the doors.
 SET I = 1;
 WHILE (I <= SIZE) DO
  SET STATUS = (CASE WHEN (DOORS[I] = TRUE) THEN 'OPEN' ELSE 'CLOSED' END);
  CALL DBMS_OUTPUT.PUT_LINE('Door ' || I || ' is '|| STATUS);
  SET I = I + 1;
 END WHILE;
END @
