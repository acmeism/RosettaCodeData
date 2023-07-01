import Text.Printf (printf)
import Control.Monad (when)

factorial :: Integral n => n -> n
factorial 0 = 1
factorial n = product [1..n]

lah :: Integral n => n -> n -> n
lah n k
  | k == 1 = factorial n
  | k == n = 1
  | k > n  = 0
  | k < 1 || n < 1 = 0
  | otherwise = f n `div` f k `div` factorial (n - k)
      where
        f = (*) =<< (^ 2) . factorial . pred

printLah :: (Word, Word) -> IO ()
printLah (n, k) = do
  when (k == 0) (printf "\n%3d" n)
  printf "%11d" (lah n k)

main :: IO ()
main = do
  printf "Unsigned Lah numbers: L(n, k):\nn/k"
  mapM_ (printf "%11d") zeroToTwelve
  mapM_ printLah $ (,) <$> zeroToTwelve <*> zeroToTwelve
  printf "\nMaximum value from the L(100, *) row:\n%d\n"
    (maximum $ lah 100 <$> ([0..100] :: [Integer]))
  where zeroToTwelve = [0..12]
