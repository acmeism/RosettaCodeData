import Text.Printf (printf)
import Data.List (groupBy)
import qualified Data.MemoCombinators as Memo

stirling2 :: Integral a => (a, a) -> a
stirling2 = Memo.pair Memo.integral Memo.integral f
  where
    f (n, k)
      | n == 0 && k == 0 = 1
      | (n > 0 && k == 0) || (n == 0 && k > 0) = 0
      | n == k = 1
      | k > n = 0
      | otherwise = k * stirling2 (pred n, k) + stirling2 (pred n, pred k)

main :: IO ()
main = do
  printf "n/k"
  mapM_ (printf "%10d") ([0..12] :: [Int]) >> printf "\n"
  printf "%s\n" $ replicate (13 * 10 + 3) '-'
  mapM_ (\row -> printf "%2d|" (fst $ head row) >>
    mapM_ (printf "%10d" . stirling2) row >> printf "\n") table
  printf "\nThe maximum value of S2(100, k):\n%d\n" $
    maximum ([stirling2 (100, n) | n <- [1..100]] :: [Integer])
  where
    table :: [[(Int, Int)]]
    table = groupBy (\a b -> fst a == fst b) $ (,) <$> [0..12] <*> [0..12]
