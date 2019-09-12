import Data.Array (Array, (!), listArray)

happy :: Int -> Bool
happy x
  | xx <= 150 = seen ! xx
  | otherwise = happy xx
  where
    xx = dsum x
    seen :: Array Int Bool
    seen =
      listArray (1, 150) $ True : False : False : False : (happy <$> [5 .. 150])
    dsum n
      | n < 10 = n * n
      | otherwise =
        let (q, r) = n `divMod` 10
        in r * r + dsum q

main :: IO ()
main = print $ sum $ take 10000 $ filter happy [1 ..]
