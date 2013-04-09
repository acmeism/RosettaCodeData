FUNCTION binary_search ( array() AS Integer, value AS Integer, lo AS Integer, hi AS Integer) AS Integer
  DIM middle AS Integer

  WHILE lo <= hi
    middle = (hi + lo) / 2
    SELECT CASE value
      CASE IS < array(middle)
	hi = middle - 1
      CASE IS > array(middle)
	lo = middle + 1
      CASE ELSE
	binary_search = middle
	EXIT FUNCTION
    END SELECT
  WEND
  binary_search = 0
END FUNCTION
