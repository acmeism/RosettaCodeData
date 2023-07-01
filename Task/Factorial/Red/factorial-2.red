fac: func [n][either n > 1 [n * fac n - 1][1]]
fac: func [n][any [if n = 0 [1] n * fac n - 1]]
fac: func [n][do pick [[n * fac n - 1] 1] n > 1]
