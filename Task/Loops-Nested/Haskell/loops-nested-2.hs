mij :: [[Int]]
mij = takeWhile(not.null). unfoldr (Just. splitAt 5) $
      [2, 6, 17, 5, 14, 1, 9, 11, 18, 10, 13, 20, 8, 7, 4, 16, 15, 19, 3, 12]

*Main> mapM_ (mapM_ print) $ taskLLB 20 mij
2
6
17
5
14
1
9
11
18
10
13
20
