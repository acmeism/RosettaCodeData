import Data.Ord (comparing)
import Data.List (maximumBy, intercalate)

hailstone :: Int -> [Int]
hailstone 1 = [1]
hailstone n
  | even n = n : hailstone (n `div` 2)
  | otherwise = n : hailstone (n * 3 + 1)

withResult :: (Int -> Int) -> Int -> (Int, Int)
withResult f x = (f x, x)

h27 :: [Int]
h27 = hailstone 27

main :: IO ()
main =
  mapM_
    putStrLn
    [ (show . length) h27
    , "hailstone 27: " ++
      intercalate " ... " (show <$> [take 4 h27, drop (length h27 - 4) h27])
    , show $
      maximumBy (comparing fst) $
      withResult (length . hailstone) <$> [1 .. 100000]
    ]
