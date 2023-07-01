CREATE TABLESPACE myTs;

COMMENT ON TABLESPACE myTs IS 'Description of the tablespace.';

CREATE SCHEMA mySch;

COMMENT ON SCHEMA mySch IS 'Description of the schema.';

CREATE TYPE myType AS (col1 int) MODE DB2SQL;

COMMENT ON TYPE mytype IS 'Description of the type.';

CREATE TABLE myTab (
  myCol1 INT NOT NULL,
  myCol2 INT
);

COMMENT ON TABLE myTab IS 'Description of the table.';
COMMENT ON myTab (
  myCol1 IS 'Description of the column.',
  myCol2 IS 'Description of the column.'
);

ALTER TABLE myTab ADD CONSTRAINT myConst PRIMARY KEY (myCol1);

COMMENT ON CONSTRAINT myTab.myConst IS 'Description of the constraint.';

CREATE INDEX myInd ON
  myTab (myCol2);

COMMENT ON INDEX myInd IS 'Description of the index.';

-- V11.1
CREATE USAGE LIST myUsList FOR TABLE myTab;

COMMENT ON USAGE LISTmyUsList IS 'Description of the usage list.';

/**
 * Detailed description of the trigger.
 */
CREATE TRIGGER myTrig
  AFTER INSERT ON myTab
  REFERENCING NEW AS N
  FOR EACH ROW
 BEGIN
 END;

COMMENT ON TRIGGER myTrig IS 'General description of the trigger.';

CREATE VARIABLE myVar INT;

COMMENT ON VARIABLE myVar IS 'General description of the variable.';

/**
 * General description of the function (reads until the first dot).
 * Detailed description of the function, until the first empty line.
 *
 * IN VAR1
 *   Description of IN parameter in variable VAR1.
 * OUT VAR2
 *   Description of OUT parameter in variable VAR2.
 * INOUT VAR3
 *   Description of INOUT parameter in variable VAR3.
 * RETURNS Description of what it returns.
 */
CREATE FUNCTION myfun (
  IN VAR1 INT,
  OUT VAR2 INT,
  INOUT VAR3 INT)
  RETURNS INT
 BEGIN
 END;

/**
 * General description of the procedure (reads until the first dot).
 * Detailed description of the procedure, until the first empty line.
 *
 * IN VAR1
 *   Description of IN parameter in variable VAR1.
 * OUT VAR2
 *   Description of OUT parameter in variable VAR2.
 * INOUT VAR3
 *   Description of INOUT parameter in variable VAR3.
 */
CREATE PROCEDURE myProc (
  IN VAR1 INT,
  OUT VAR2 INT,
  INOUT VAR3 INT)
 BEGIN
 END;

CREATE MODULE myMod;

COMMENT ON MODULE myMod IS 'General description of the module.';

/**
 * General description of the procedure (reads until the first dot).
 * Detailed description of the procedure, until the first empty line.
 *
 * IN VAR1
 *   Description of IN parameter in variable VAR1.
 * OUT VAR2
 *   Description of OUT parameter in variable VAR2.
 * INOUT VAR3
 *   Description of INOUT parameter in variable VAR3.
 */
ALTER MODULE myMod
  ADD PROCEDURE myProc (
  IN VAR1 INT,
  OUT VAR2 INT,
  INOUT VAR3 INT)
 BEGIN
 END;

CREATE ROLE myRole;

COMMENT ON ROLE myRole IS 'Description of the role.';

CREATE SEQUENCE mySeq;

COMMENT ON ROLE mySeq IS 'Description of the sequence.';
