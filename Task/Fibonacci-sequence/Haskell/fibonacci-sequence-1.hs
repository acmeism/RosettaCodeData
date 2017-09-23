main :: IO ()
main =
  print
    [ floor (0.01 + (1 / p ** n + p ** n) / sqrt 5)
    | let p = (1 + sqrt 5) / 2
    , n <- [0 .. 42] ]
