testList = [ (3, "Clear drains"),
             (4, "Feed cat"),
             (5, "Make tea"),
             (1, "Solve RC tasks"),
             (2, "Tax return") ]

testPQ = fromListPQ testList

main = do -- slow build
  mapM_ print $ toListPQ $ foldl (\pq (k, v) -> pushPQ k v pq) emptyPQ testList
  putStrLn "" -- fast build
  mapM_ print $ toListPQ $ fromListPQ testList
  putStrLn "" -- combined fast sort
  mapM_ print $ sortPQ testList
  putStrLn "" -- test merge
  mapM_ print $ toListPQ $ mergePQ testPQ testPQ
  putStrLn "" -- test adjust
  mapM_ print $ toListPQ $ adjustPQ (\x y -> (x * (-1), y)) testPQ
