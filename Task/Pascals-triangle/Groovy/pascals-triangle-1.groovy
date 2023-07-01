def pascal
pascal = { n -> (n <= 1) ? [1] : [[0] + pascal(n - 1), pascal(n - 1) + [0]].transpose().collect { it.sum() } }
