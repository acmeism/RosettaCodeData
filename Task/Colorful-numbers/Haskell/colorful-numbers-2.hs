import Data.List (inits, nub, tails, unfoldr)

-- Non-empty subsequences containing only consecutive elements from the
-- argument.  For example:
--
--   consecs [1,2,3]  =>  [[1],[1,2],[1,2,3],[2],[2,3],[3]]
consecs :: [a] -> [[a]]
consecs = drop 1 . ([] :) . concatMap (drop 1 . inits) . tails

-- The list of digits in the argument, from least to most significant.  The
-- number 0 is represented by the empty list.
toDigits :: Int -> [Int]
toDigits = unfoldr step
  where step 0 = Nothing
        step n = let (q, r) = n `quotRem` 10 in Just (r, q)

-- True if and only if all the argument's elements are distinct.
allDistinct :: [Int] -> Bool
allDistinct ns = length ns == length (nub ns)

-- True if and only if the argument is a colorful number.
isColorful :: Int -> Bool
isColorful = allDistinct . map product . consecs . toDigits

main :: IO ()
main = do
  let smalls = filter isColorful [0..99]
  putStrLn $ "Small colorful numbers: " ++ show smalls

  let start = 98765432
      largest = head $ dropWhile (not . isColorful) [start, start-1 ..]
  putStrLn $ "Largest colorful number: " ++ show largest
