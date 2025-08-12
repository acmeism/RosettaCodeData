loop :: (b -> a -> b) -> b -> [[a]] -> b
loop = foldl . foldl

example = let
  x = 5
  y = -5
  z = -2
  one = 1
  three = 3
  seven = 7
  in
    loop
    -- body
    (
      \(sum, prod) j ->
        (
          sum + abs j,
          if abs prod < 2^27 && j /= 0
          then prod * j else prod
        )
    )
    -- initial state
    (0, 1)
    -- ranges
    [ [-three, -three + three .. 3^3]
      , [-seven, -seven + x .. seven]
      , [555 .. 550 - y]
      , [22, 22 - three .. -28]
      , [1927 .. 1939]
      , [x, x + z .. y]
      , [11^x ..  11^x + one] ]
