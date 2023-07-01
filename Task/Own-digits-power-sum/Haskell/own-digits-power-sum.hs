import Data.List (sort)

------------------- OWN DIGITS POWER SUM -----------------

ownDigitsPowerSums :: Int -> [Int]
ownDigitsPowerSums n = sort (ns >>= go)
  where
    ns = combsWithRep n [0 .. 9]
    go xs
      | digitsMatch m xs = [m]
      | otherwise = []
      where
        m = foldr ((+) . (^ n)) 0 xs

digitsMatch :: Show a => a -> [Int] -> Bool
digitsMatch n ds =
  sort ds == sort (digits n)

--------------------------- TEST -------------------------
main :: IO ()
main = do
  putStrLn "N ∈ [3 .. 8]"
  mapM_ print ([3 .. 8] >>= ownDigitsPowerSums)
  putStrLn ""
  putStrLn "N=9"
  mapM_ print $ ownDigitsPowerSums 9

------------------------- GENERIC ------------------------
combsWithRep ::
  (Eq a) =>
  Int ->
  [a] ->
  [[a]]
combsWithRep k xs = comb k []
  where
    comb 0 ys = ys
    comb n [] = comb (pred n) (pure <$> xs)
    comb n peers = comb (pred n) (peers >>= nextLayer)
      where
        nextLayer ys@(h : _) =
          (: ys) <$> dropWhile (/= h) xs

digits :: Show a => a -> [Int]
digits n = (\x -> read [x] :: Int) <$> show n
