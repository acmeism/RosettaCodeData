HailstoneR[1] := {1}
HailstoneR[n_Integer] := Prepend[HailstoneR[3 n + 1], n] /; OddQ[n] && n > 0
HailstoneR[n_Integer] := Prepend[HailstoneR[n/2], n] /; EvenQ[n] && n > 0
