import Data.List (permutations)

main :: IO ()
main =
  print
    [ ( "Baker lives on " ++ show b
      , "Cooper lives on " ++ show c
      , "Fletcher lives on " ++ show f
      , "Miller lives on " ++ show m
      , "Smith lives on " ++ show s)
    | [b, c, f, m, s] <- permutations [1 .. 5]
    , b /= 5
    , c /= 1
    , f /= 1
    , f /= 5
    , m > c
    , abs (s - f) > 1
    , abs (c - f) > 1 ]
