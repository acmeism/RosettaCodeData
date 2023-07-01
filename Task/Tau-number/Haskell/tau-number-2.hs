import Data.List (group, scanl)
import Data.List.Split (chunksOf)
import Data.Numbers.Primes (primeFactors)

----------------------- TAU NUMBERS ----------------------

tauNumbers :: [Int]
tauNumbers =
  filter
    ((0 ==) . (rem <*> (length . divisors)))
    [1 ..]

--------------------------- TEST -------------------------
main :: IO ()
main =
  let xs = take 100 $ fmap show tauNumbers
      w = length $ last xs
   in (putStrLn . unlines) $
        unwords . fmap (justifyRight w ' ')
          <$> chunksOf 10 xs

------------------------- GENERIC ------------------------

divisors :: Int -> [Int]
divisors =
  foldr
    (flip ((<*>) . fmap (*)) . scanl (*) 1)
    [1]
    . group
    . primeFactors

justifyRight :: Int -> Char -> String -> String
justifyRight n c = (drop . length) <*> (replicate n c <>)
