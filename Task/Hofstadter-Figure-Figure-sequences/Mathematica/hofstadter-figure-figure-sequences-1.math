 ffr[j_] := Module[{R = {1}, S = 2, k = 1},
    Do[While[Position[R, S] != {}, S++]; k = k + S; S++;
    R = Append[R, k], {n, 1, j - 1}]; R]

 ffs[j_] := Differences[ffr[j + 1]]
