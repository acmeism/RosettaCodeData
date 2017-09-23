import Data.List (mapAccumL)

roman :: Int -> String
roman n =
  concat
    (snd
       (mapAccumL
          (\a (m, s) ->
              let (q, r) = quotRem a m
              in (r, [1 .. q] >> s))
          n
          [ (1000, "M")
          , (900, "CM")
          , (500, "D")
          , (400, "CD")
          , (100, "C")
          , (90, "XC")
          , (50, "L")
          , (40, "XL")
          , (10, "X")
          , (9, "IX")
          , (5, "V")
          , (4, "IV")
          , (1, "I")
          ]))

main :: IO ()
main = mapM_ (putStrLn . roman) [1666, 1990, 2008, 2016, 2017]
