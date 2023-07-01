import Data.List (delete, sort)

-- Functions by Reinhard Zumkeller
ffr :: Int -> Int
ffr n = rl !! (n - 1)
  where
    rl = 1 : fig 1 [2 ..]
    fig n (x:xs) = n_ : fig n_ (delete n_ xs)
      where
        n_ = n + x

ffs :: Int -> Int
ffs n = rl !! n
  where
    rl = 2 : figDiff 1 [2 ..]
    figDiff n (x:xs) = x : figDiff n_ (delete n_ xs)
      where
        n_ = n + x

main :: IO ()
main = do
  print $ ffr <$> [1 .. 10]
  let i1000 = sort (fmap ffr [1 .. 40] ++ fmap ffs [1 .. 960])
  print (i1000 == [1 .. 1000])
