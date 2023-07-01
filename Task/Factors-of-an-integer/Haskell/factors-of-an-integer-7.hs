import Data.List (sort)

factorsCo n =
  sort
    [ i
    | i <- [1 .. floor (sqrt (fromIntegral n))]
    , (d, 0) <- [divMod n i]
    , i <-
       i :
       [ d
       | d > i ] ]
