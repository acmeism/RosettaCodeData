*Main> mapM_ print $ doWhile ((/=0).(`mod`6)) succ 0
0
1
2
3
4
5
