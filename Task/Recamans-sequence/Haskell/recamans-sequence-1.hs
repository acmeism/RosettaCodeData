recaman :: Int -> [Int]
recaman n = fst <$> reverse (go n)
  where
    go 0 = []
    go 1 = [(0, 1)]
    go x =
        let xs@((r, i):_) = go (pred x)
            back = r - i
        in ( if 0 < back && not (any ((back ==) . fst) xs)
               then back
               else r + i
           , succ i) :
           xs

main :: IO ()
main = print $ recaman 15
