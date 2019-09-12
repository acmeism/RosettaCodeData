factorsNaive n =
  [ i
  | i <- [1 .. n]
  , mod n i == 0 ]
