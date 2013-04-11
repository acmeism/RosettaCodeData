def iFib = { it < 1 ? 0 : it == 1 ? 1 : (2..it).inject([0,1]){i, j -> [i[1], i[0]+i[1]]}[1] }
