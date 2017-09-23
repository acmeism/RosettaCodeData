import Prelude hiding (odd)
import Control.Monad (join)

halve :: Int -> Int
halve = (`div` 2)

double :: Int -> Int
double = join (+)

odd :: Int -> Bool
odd = (== 1) . (`mod` 2)

ethiopicmult :: Int -> Int -> Int
ethiopicmult a b =
  sum $
  map snd $
  filter (odd . fst) $
  zip (takeWhile (>= 1) $ iterate halve a) (iterate double b)

main :: IO ()
main = print $ ethiopicmult 17 34 == 17 * 34
