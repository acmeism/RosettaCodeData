import Data.List (mapAccumL)

roman :: Int -> String
roman n = concatMap concat . snd $ mapAccumL tr n
    [(1000, "M"), (900, "CM"), (500, "D") ,( 400, "CD"),
     ( 100, "C"), ( 90, "XC") ,( 50, "L"), (  40, "XL"),
     (  10, "X"), (  9, "IX"), (  5, "V"), (   4, "IV"),
     (   1, "I")]
  where
    tr a (m, s) = (r, replicate q s)
      where
        (q, r) = quotRem a m

main :: IO ()
main = mapM_ (putStrLn . roman) [1666, 1990, 2008, 2016, 2017]
