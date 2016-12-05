import Data.List

order::Ord a => [[a]] -> [a]
order [ms,ns] = snd.mapAccumL yu ls $ ks
  where
  ks = zip ms [(0::Int)..]
  ls = zip ns.sort.snd.foldl go (sort ns,[]).sort $ ks
  yu ((u,v):us) (_,y) | v == y  = (us,u)
  yu ys (x,_)                   = (ys,x)
  go ((u:us),ys) (x,y) | u == x = (us,y:ys)
  go ts _                       = ts

task ls@[ms,ns] = do
  putStrLn $ "M: " ++ ms ++ " | N: " ++ ns ++ " |> " ++ (unwords.order.map words $ ls)

main = mapM_ task [["the cat sat on the mat","mat cat"],["the cat sat on the mat","cat mat"],["A B C A B C A B C","C A C A"],["A B C A B D A B E","E A D A"],["A B","B"],["A B","B A"],["A B B A","B A"]]
