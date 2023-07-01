import Data.Ratio ((%))

-- Prints the first N perfect numbers.
main = do
  let n = 4
  mapM_ print $
    take
      n
      [ candidate
      | candidate <- [2 .. 2 ^ 19]
      , getSum candidate == 1 ]
  where
    getSum candidate =
      1 % candidate +
      sum
        [ 1 % factor + 1 % (candidate `div` factor)
        | factor <- [2 .. floor (sqrt (fromIntegral candidate))]
        , candidate `mod` factor == 0 ]
