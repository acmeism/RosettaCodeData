import Data.Bifunctor (bimap)
import Data.List (unfoldr)
import Data.Tuple (swap)

digSum :: Int -> Int -> Int
digSum base = sum . unfoldr f
  where
    f 0 = Nothing
    f n = Just (swap (quotRem n base))

digRoot :: Int -> Int -> (Int, Int)
digRoot base =
  head .
  dropWhile ((>= base) . snd) . iterate (bimap succ (digSum base)) . (,) 0

main :: IO ()
main = do
  putStrLn "in base 10:"
  mapM_ (print . ((,) <*> digRoot 10)) [627615, 39390, 588225, 393900588225]
