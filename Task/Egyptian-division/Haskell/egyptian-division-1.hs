import Data.List (unfoldr)

egyptianQuotRem :: Integer -> Integer -> (Integer, Integer)
egyptianQuotRem m n =
  let expansion (i, x)
        | x > m = Nothing
        | otherwise = Just ((i, x), (i + i, x + x))
      collapse (i, x) (q, r)
        | x < r = (q + i, r - x)
        | otherwise = (q, r)
  in foldr collapse (0, m) $ unfoldr expansion (1, n)

main :: IO ()
main = print $ egyptianQuotRem 580 34
