import Data.Numbers.Primes (primeFactors)
import Data.List (group, maximumBy, sort)
import Data.Ord (comparing)

properDivisors :: Int -> [Int]
properDivisors =
  init . sort . foldr (
    flip ((<*>) . fmap (*)) . scanl (*) 1
  ) [1] . group . primeFactors

---------------------------TEST----------------------------
main :: IO ()
main = do
  putStrLn $
    fTable "Proper divisors of [1..10]:" show show properDivisors [1 .. 10]
  mapM_
    putStrLn
    [ ""
    , "A number in the range 1 to 20,000 with the most proper divisors,"
    , "as (number, count of proper divisors):"
    , ""
    ]
  print $
    maximumBy (comparing snd) $
    (,) <*> (length . properDivisors) <$> [1 .. 20000]

--------------------------DISPLAY--------------------------
fTable :: String -> (a -> String) -> (b -> String) -> (a -> b) -> [a] -> String
fTable s xShow fxShow f xs =
  let rjust n c = (drop . length) <*> (replicate n c ++)
      w = maximum (length . xShow <$> xs)
  in unlines $
     s : fmap (((++) . rjust w ' ' . xShow) <*> ((" -> " ++) . fxShow . f)) xs
