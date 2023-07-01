hammings :: () -> [Integer]
hammings() = 1 : foldr u [] [2,3,5] where
  u n s = -- fix (merge s . map (n*) . (1:))
          r where
    r = merge s (map (n*) (1:r))
    merge [] b = b
    merge a@(x:xs) b@(y:ys) | x < y     = x : merge xs b
                            | otherwise = y : merge a ys

main :: IO ()
main = do
  print $ take 20 (hammings ())
  print $ (hammings ()) !! 1690
  print $ (hammings ()) !! (1000000-1)
