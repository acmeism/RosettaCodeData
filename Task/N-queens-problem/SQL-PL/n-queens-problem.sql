-- A column of a matrix.
CREATE TYPE INTEGER_ARRAY AS INTEGER ARRAY[]@
-- The whole matrix of any size.
CREATE TYPE INTEGER_MATRIX AS INTEGER_ARRAY ARRAY[]@

/**
 * Retrieves the value from a matrix at a specific position.
 *
 * IN X: Row number.
 * IN Y: Column number.
 * IN M: Matrix.
 * RETURN the integer value at that position.
 */
CREATE OR REPLACE FUNCTION GET_INTEGER_VALUE(
  IN X SMALLINT,
  IN Y SMALLINT,
  IN M INTEGER_MATRIX)
RETURNS INTEGER
F_GET_INTEGER_VALUE: BEGIN
  DECLARE A INTEGER_ARRAY;
  DECLARE RET INTEGER;

  SET A = M[X];
  SET RET = A[Y];
  RETURN RET;
END F_GET_INTEGER_VALUE
@

/**
 * Establishes the given value at a specific position in the matrix.
 *
 * IN X: Row number.
 * IN Y: Column number.
 * INOUT M: Matrix.
 * IN VAL: Value to set in the matrix.
 */
CREATE OR REPLACE PROCEDURE SET_INTEGER_VALUE(
  IN X SMALLINT,
  IN Y SMALLINT,
  INOUT M INTEGER_MATRIX,
  IN VAL INTEGER)
P_SET_INTEGER_VALUE: BEGIN
  DECLARE A INTEGER_ARRAY;

  SET A = M[X];
  SET A[Y] = VAL;
  SET M[X] = A;
END P_SET_INTEGER_VALUE
@

/**
 * Initializes the matriz at a given size with the same value in all positions.
 *
 * INOUT M: Matrix.
 * IN X: Number of rows.
 * IN Y: Number of columns per row.
 * IN VAL: Value to set in the matrix.
 */
CREATE OR REPLACE PROCEDURE INIT_INTEGER_MATRIX(
  INOUT M INTEGER_MATRIX,
  IN X SMALLINT,
  IN Y SMALLINT,
  IN VAL INTEGER)
P_INIT_INTEGER_MATRIX: BEGIN
  DECLARE I SMALLINT DEFAULT 1;
  DECLARE J SMALLINT;
  DECLARE A INTEGER_ARRAY;

  WHILE (I <= X) DO
   SET A = ARRAY[];
   SET J = 1;
   WHILE (J <= Y) DO
    SET A[J] = VAL;
    SET J = J + 1;
   END WHILE;
   SET M[I] = A;
   SET I = I + 1;
  END WHILE;
END P_INIT_INTEGER_MATRIX
@

/**
 * Prints the content of the matrix to the standard output.
 *
 * INOUT M: Matrix.
 */
CREATE OR REPLACE PROCEDURE PRINT_INTEGER_MATRIX(
  IN M INTEGER_MATRIX)
P_PRINT_INTEGER_MATRIX: BEGIN
  DECLARE I SMALLINT DEFAULT 1;
  DECLARE J SMALLINT;
  DECLARE X SMALLINT;
  DECLARE Y SMALLINT;
  DECLARE VAL INTEGER;
  DECLARE A INTEGER_ARRAY;
  DECLARE RET VARCHAR(256);

  SET X = CARDINALITY(M);
  CALL DBMS_OUTPUT.PUT_LINE('>>>>>');
  WHILE (I <= X) DO
   SET A = M[I];
   SET RET = '[';
   SET Y = CARDINALITY(A);
   SET J = 1;
   WHILE (J <= Y) DO
    SET VAL = A[J];
    SET RET = RET || VAL;
    SET J = J + 1;
    IF (J <= Y) THEN
     SET RET = RET || ',';
    END IF;
   END WHILE;
   SET RET = RET || ']';
   CALL DBMS_OUTPUT.PUT_LINE(RET);
   SET I = I + 1;
  END WHILE;
  CALL DBMS_OUTPUT.PUT_LINE('<<<<<');
END P_PRINT_INTEGER_MATRIX
@

/**
 * Checks if a queen is safe in the given position.
 *
 * IN M: Matrix representing the chessboard.
 * IN ROW: Row of the queen.
 * IN COL: Column in the row for the queen.
 * IN SIZE: Size of the chessboard (max row, max col).
 * RETURNS true if the position is safe.
 */
CREATE OR REPLACE FUNCTION IS_SAFE(
  IN M INTEGER_MATRIX,
  IN ROW SMALLINT,
  IN COL SMALLINT,
  IN SIZE SMALLINT)
 MODIFIES SQL DATA
 RETURNS BOOLEAN
 F_IS_SAFE: BEGIN
  DECLARE I SMALLINT;
  DECLARE J SMALLINT;
  DECLARE VAL INTEGER;

  -- Debug purposes.
  --CALL SET_INTEGER_VALUE(ROW, COL, M, -1);
  --CALL PRINT_INTEGER_MATRIX(M);
  --CALL SET_INTEGER_VALUE(ROW, COL, M, 0);

  SET I = 1;
  WHILE (I <= COL) DO
   SET VAL = GET_INTEGER_VALUE(ROW, I, M);
   IF (VAL = 1) THEN
    RETURN FALSE;
   END IF;
   SET I = I + 1;
  END WHILE;

  SET I = ROW;
  SET J = COL;
  WHILE (I >= 1 AND J >= 1) DO
   SET VAL = GET_INTEGER_VALUE(I, J, M);
   IF (VAL = 1) THEN
    CALL SET_INTEGER_VALUE(ROW, COL, M, 0);
    RETURN FALSE;
   END IF;
   SET I = I - 1;
   SET J = J - 1;
  END WHILE;

  SET I = ROW;
  SET J = COL;
  WHILE (J >= 1 AND I <= SIZE) DO
   SET VAL = GET_INTEGER_VALUE(I, J, M);
   IF (VAL = 1) THEN
    RETURN FALSE;
   END IF;
   SET I = I + 1;
   SET J = J - 1;
  END WHILE;

  RETURN TRUE;
 END F_IS_SAFE
@

/**
 * Dummy procedure for the recurssion.
 *
 * IN SIZE: Size of the chessboard (max row, max col).
 * IN COL: Column to analyse.
 * OUT RET: True if it was possible to put all queens
 */
CREATE OR REPLACE PROCEDURE SOLVE_N_QUEENS(
  INOUT M INTEGER_MATRIX,
  IN SIZE SMALLINT,
  IN COL SMALLINT,
  OUT RET BOOLEAN)
 P_SOLVE_N_QUEENS: BEGIN
 END P_SOLVE_N_QUEENS
@

/**
 * Solves the n-queens algoritm.
 *
 * IN SIZE: Size of the chessboard (max row, max col).
 * IN COL: Column to analyse.
 * OUT RET: True if it was possible to put all queens
 */
CREATE OR REPLACE PROCEDURE SOLVE_N_QUEENS(
  INOUT M INTEGER_MATRIX,
  IN SIZE SMALLINT,
  IN COL SMALLINT,
  OUT RET BOOLEAN)
 MODIFIES SQL DATA
 P_SOLVE_N_QUEENS: BEGIN
  DECLARE I SMALLINT;
  DECLARE SAFE BOOLEAN;
  DECLARE SOLVED BOOLEAN;

  -- Debug purposes.
  --CALL PRINT_INTEGER_MATRIX(M);
  SET RET = FALSE;
  IF (COL > SIZE) THEN
   SET RET = TRUE;
  ELSE
   SET I = 1;
   WHILE (I <= SIZE AND NOT RET) DO
    SET SAFE = IS_SAFE(M, I, COL, SIZE);
    IF (SAFE) THEN
     CALL SET_INTEGER_VALUE(I, COL, M, 1);
     CALL SOLVE_N_QUEENS(M, SIZE, COL + 1, SOLVED);
     IF (SOLVED) THEN
      SET RET = TRUE;
     ELSE
      CALL SET_INTEGER_VALUE(I, COL, M, 0); -- Backtrack.
     END IF;

    END IF;

    SET I = I + 1;
   END WHILE;

  END IF;
 END P_SOLVE_N_QUEENS
@

/**
 * Main procedure to solve the n-queen algoritm.
 *
 * IN SIZE: Size of the chessboard. The bigger it is, the more time it takes.
 */
CREATE OR REPLACE PROCEDURE N_QUEENS(
  IN SIZE SMALLINT)
 P_N_QUEENS: BEGIN
  DECLARE M INTEGER_MATRIX;
  DECLARE SOL BOOLEAN DEFAULT FALSE;

  CALL INIT_INTEGER_MATRIX(M, SIZE, SIZE, 0);

  CALL SOLVE_N_QUEENS(M, SIZE, 1, SOL);
  IF (SOL = TRUE) THEN
   CALL PRINT_INTEGER_MATRIX(M);
  ELSE
   CALL DBMS_OUTPUT.PUT_LINE('Solution does not exist.');
  END IF;

 END P_N_QUEENS
@

--#SET TERMINATOR ;

-- Activates the standard output for the current session.
SET SERVEROUTPUT ON;

CALL N_QUEENS(4);

CALL N_QUEENS(8);

CALL N_QUEENS(16);
