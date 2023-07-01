import Data.List (partition)

nth :: Ord t => [t] -> Int -> t
nth (x:xs) n
  | k == n = x
  | k > n = nth ys n
  | otherwise = nth zs $ n - k - 1
  where
    (ys, zs) = partition (< x) xs
    k = length ys

medianMay :: (Fractional a, Ord a) => [a] -> Maybe a
medianMay xs
  | n < 1 = Nothing
  | even n = Just ((nth xs (div n 2) + nth xs (div n 2 - 1)) / 2.0)
  | otherwise = Just (nth xs (div n 2))
  where
    n = length xs

main :: IO ()
main =
  mapM_
    (printMay . medianMay)
    [[], [7], [5, 3, 4], [5, 4, 2, 3], [3, 4, 1, -8.4, 7.2, 4, 1, 1.2]]
  where
    printMay = maybe (putStrLn "(not defined)") print
