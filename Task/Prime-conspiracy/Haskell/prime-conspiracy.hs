import Data.List (group, sort)
import Text.Printf (printf)
import Data.Numbers.Primes (primes)

freq :: [(Int, Int)] -> Float
freq xs = realToFrac (length xs) / 100

line :: [(Int, Int)] -> IO ()
line t@((n1, n2):xs) = printf "%d -> %d count: %5d frequency: %2.2f %%\n" n1 n2 (length t) (freq t)

main :: IO ()
main = mapM_ line $ groups primes
  where groups = tail . group . sort . (\n -> zip (0: n) n) . fmap (`mod` 10) . take 10000
