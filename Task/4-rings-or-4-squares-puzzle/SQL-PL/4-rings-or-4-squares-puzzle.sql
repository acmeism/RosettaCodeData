--#SET TERMINATOR @

SET SERVEROUTPUT ON @

CREATE TABLE ALL_INTS (
  V INTEGER
)@

CREATE TABLE RESULTS (
  A INTEGER,
  B INTEGER,
  C INTEGER,
  D INTEGER,
  E INTEGER,
  F INTEGER,
  G INTEGER
)@

CREATE OR REPLACE PROCEDURE FOUR_SQUARES(
  IN LO INTEGER,
  IN HI INTEGER,
  IN UNIQ SMALLINT,
  --IN UNIQ BOOLEAN,
  IN SHOW SMALLINT)
  --IN SHOW BOOLEAN)
 BEGIN
  DECLARE A INTEGER;
  DECLARE B INTEGER;
  DECLARE C INTEGER;
  DECLARE D INTEGER;
  DECLARE E INTEGER;
  DECLARE F INTEGER;
  DECLARE G INTEGER;
  DECLARE OUT_LINE VARCHAR(2000);
  DECLARE I SMALLINT;

  DECLARE SOLUTIONS INTEGER;
  DECLARE UORN VARCHAR(2000);

  SET SOLUTIONS = 0;
  DELETE FROM ALL_INTS;
  DELETE FROM RESULTS;
  SET I = LO;
  WHILE (I <= HI) DO
   INSERT INTO ALL_INTS VALUES (I);
   SET I = I + 1;
  END WHILE;
  COMMIT;

  -- Computes unique solutions.
  IF (UNIQ = 0) THEN
  --IF (UNIQ = TRUE) THEN
   INSERT INTO RESULTS
     SELECT
      A.V A, B.V B, C.V C, D.V D, E.V E, F.V F, G.V G
     FROM
      ALL_INTS A, ALL_INTS B, ALL_INTS C, ALL_INTS D, ALL_INTS E, ALL_INTS F,
      ALL_INTS G
     WHERE
          A.V NOT IN (B.V, C.V, D.V, E.V, F.V, G.V)
      AND B.V NOT IN (C.V, D.V, E.V, F.V, G.V)
      AND C.V NOT IN (D.V, E.V, F.V, G.V)
      AND D.V NOT IN (E.V, F.V, G.V)
      AND E.V NOT IN (F.V, G.V)
      AND F.V NOT IN (G.V)
      AND A.V = C.V + D.V
      AND G.V = D.V + E.V
      AND B.V = E.V + F.V - C.V
     ORDER BY
      A, B, C, D, E, F, G;
   SET UORN = ' unique solutions in ';
  ELSE
   -- Compute non-unique solutions.
   INSERT INTO RESULTS
     SELECT
      A.V A, B.V B, C.V C, D.V D, E.V E, F.V F, G.V G
     FROM
      ALL_INTS A, ALL_INTS B, ALL_INTS C, ALL_INTS D, ALL_INTS E, ALL_INTS F,
      ALL_INTS G
     WHERE
          A.V = C.V + D.V
      AND G.V = D.V + E.V
      AND B.V = E.V + F.V - C.V
     ORDER BY
      A, B, C, D, E, F, G;
   SET UORN = ' non-unique solutions in ';
  END IF;
  COMMIT;

  -- Counts the possible solutions.
  FOR v AS c CURSOR FOR
    SELECT
     A, B, C, D, E, F, G
    FROM RESULTS
    ORDER BY
     A, B, C, D, E, F, G
    DO
   SET SOLUTIONS = SOLUTIONS + 1;
   -- Shows the results.
   IF (SHOW = 0) THEN
   --IF (SHOW = TRUE) THEN
    SET OUT_LINE = A || ' ' || B || ' ' || C || ' ' || D || ' ' || E || ' '
      || F ||' ' || G;
    CALL DBMS_OUTPUT.PUT_LINE(OUT_LINE);
   END IF;
  END FOR;

  SET OUT_LINE = SOLUTIONS || UORN || LO || ' to ' || HI;
  CALL DBMS_OUTPUT.PUT_LINE(OUT_LINE);
 END
@

CALL FOUR_SQUARES(1, 7, 0, 0)@
CALL FOUR_SQUARES(3, 9, 0, 0)@
CALL FOUR_SQUARES(0, 9, 1, 1)@
