FUNCTION binary_search ( array() AS Integer, value AS Integer, lo AS Integer, hi AS Integer) AS Integer
  DIM middle AS Integer

  IF hi < lo THEN
    binary_search = 0
  ELSE
    middle = (hi + lo) / 2
    SELECT CASE value
      CASE IS < array(middle)
	binary_search = binary_search(array(), value, lo, middle-1)
      CASE IS > array(middle)
	binary_search = binary_search(array(), value, middle+1, hi)
      CASE ELSE
	binary_search = middle
    END SELECT
  END IF
END FUNCTION
