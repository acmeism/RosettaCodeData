CREATE OR REPLACE PROCEDURE TEST_MY_TEST()
  BEGIN
    DECLARE EXPECTED INTEGER;
    DECLARE ACTUAL INTEGER;
    CALL DB2UNIT.REGISTER_MESSAGE('My first test');
    SET EXPECTED = 2;
    SET ACTUAL = 1+1;
    CALL DB2UNIT.ASSERT_INT_EQUALS('Same value', EXPECTED, ACTUAL);
  END @
