import Data.List (maximumBy, permutations, delete)
import Data.Ord (comparing)
import Data.Bool (bool)

unDigits :: [Int] -> Int
unDigits = foldl ((+) . (10 *)) 0

ds :: [Int]
ds = [1, 2, 3, 4, 6, 7, 8, 9] -- 0 (and thus 5) are both unworkable

lcmDigits :: Int
lcmDigits = foldr1 lcm ds -- 504

sevenDigits :: [[Int]]
sevenDigits = (`delete` ds) <$> [1, 4, 7] -- Dropping any one of these three

main :: IO ()
main =
  print $
  maximumBy
  -- Checking for divisibility by all digits
    (comparing (bool 0 <*> (0 ==) . (`rem` lcmDigits)))
    (unDigits <$> concat (permutations <$> sevenDigits))
