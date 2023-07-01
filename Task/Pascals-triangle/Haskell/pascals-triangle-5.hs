-- generate next row from current row
nextRow row = zipWith (+) ([0] ++ row) (row ++ [0])

-- returns the first n rows
pascal = iterate nextRow [1]
