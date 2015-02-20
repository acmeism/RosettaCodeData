import Data.List (partition)

quickselect :: Ord a => Int -> [a] -> a
quickselect k (x:xs) | k < l     = quickselect k ys
                     | k > l     = quickselect (k-l-1) zs
                     | otherwise = x
  where (ys, zs) = partition (< x) xs
        l = length ys

main :: IO ()
main = do
  let v = [9, 8, 7, 6, 5, 0, 1, 2, 3, 4]
  print $ map (\i -> quickselect i v) [0 .. length v-1]
