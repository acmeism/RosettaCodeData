import Data.Ord
import Data.List

divisors :: (Integral a) => a -> [a]
divisors n = filter ((0 ==) . (n `mod`)) [1 .. (n `div` 2)]

main :: IO ()
main = do
  putStrLn "divisors of 1 to 10:"
  mapM_ (print . divisors) [1 .. 10]
  putStrLn "a number with the most divisors within 1 to 20000 (number, count):"
  print $ maximumBy (comparing snd)
    [(n, length $ divisors n) | n <- [1 .. 20000]]
