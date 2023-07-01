import Data.List (find)
import Data.Ratio

--------------------- HARMONIC SERIES --------------------

harmonic :: [Rational]
harmonic =
  scanl1
    (\a x -> a + 1 / x)
    [1 ..]

-------------------------- TESTS -------------------------
main :: IO ()
main = do
  putStrLn "First 20 terms:"
  mapM_ putStrLn $
    showRatio <$> take 20 harmonic

  putStrLn "\n100th term:"
  putStrLn $ showRatio (harmonic !! 99)
  putStrLn ""

  putStrLn "One-based indices of first terms above threshold values:"
  let indexedHarmonic = zip [0 ..] harmonic
  mapM_
    putStrLn
    $ fmap
      ( showFirstLimit
          <*> \n -> find ((> n) . snd) indexedHarmonic
      )
      [1 .. 10]

-------------------- DISPLAY FORMATTING ------------------

showFirstLimit n (Just (i, r)) =
  "Term "
    <> show (succ i)
    <> " is the first above "
    <> show (numerator n)

showRatio :: Ratio Integer -> String
showRatio =
  ((<>) . show . numerator)
    <*> (('/' :) . show . denominator)
