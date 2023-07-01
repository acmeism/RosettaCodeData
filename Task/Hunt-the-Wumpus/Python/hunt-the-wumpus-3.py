>>> import wumpus
>>> WG = wumpus.WumpusGame()
>>> edges = [[i, WG.cave[i][j]] for i in WG.cave.keys() for j in range(len(WG.cave[i]))]
>>> print edges
[[1,2], [1,3], [1,4], [2,1], [2,5], [2,6], [3,1], ...]
