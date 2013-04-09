SUB search (array() AS Integer, value AS Integer)
  DIM idx AS Integer

  idx = binary_search(array(), value, LBOUND(array), UBOUND(array))
  PRINT "Value "; value;
  IF idx < 1 THEN
    PRINT " not found"
  ELSE
    PRINT " found at index "; idx
  END IF
END SUB

DIM test(1 TO 10) AS Integer
DIM i AS Integer

DATA 2, 3, 5, 6, 8, 10, 11, 15, 19, 20
FOR i = 1 TO 10		' Fill the test array
  READ test(i)
NEXT i

search test(), 4
search test(), 8
search test(), 20
