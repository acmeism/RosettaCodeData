import Data.List (elemIndex)
import Data.Maybe (maybe)

vanEck :: Int -> [Int]
vanEck n = reverse $ iterate go [] !! n
  where
    go [] = [0]
    go xxs@(x:xs) = maybe 0 succ (elemIndex x xs) : xxs

main :: IO ()
main = do
  print $ vanEck 10
  print $ drop 990 (vanEck 1000)
