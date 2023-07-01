import Data.List (unfoldr)
import Data.Tuple (swap)

----------------- SUM DIGITS OF AN INTEGER ---------------

baseDigitSum :: Int -> Int -> Int
baseDigitSum base = sum . unfoldr go
  where
    go x
      | 0 < x = (Just . swap) $ quotRem x base
      | otherwise = Nothing

-------------------------- TESTS -------------------------
main :: IO ()
main =
  mapM_
    print
    [ baseDigitSum <$> [2, 8, 10, 16] <*> [255],
      baseDigitSum <$> [10] <*> [1, 1234],
      baseDigitSum <$> [16] <*> [0xfe, 0xf0e]
    ]
