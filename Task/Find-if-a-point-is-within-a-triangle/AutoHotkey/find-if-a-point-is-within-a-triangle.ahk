T := [[1.5, 2.4], [5.1, -3.1], [-3.8, 1.2]]
for i, p in [[0, 0], [0, 1], [3, 1], [5.4142857, 14.349206]]
    result .= "[" p.1 ", " p.2 "]  is within triangle?`t" (TriHasP(T, p) ? "ture" : "false") "`n"
MsgBox % result
return

TriHasP(T, P){
    Ax := TriArea(T.1.1, T.1.2,  T.2.1, T.2.2,  T.3.1, T.3.2)
    A1 := TriArea(P.1  , P.2  ,  T.2.1, T.2.2,  T.3.1, T.3.2)
    A2 := TriArea(T.1.1, T.1.2,  P.1  , P.2  ,  T.3.1, T.3.2)
    A3 := TriArea(T.1.1, T.1.2,  T.2.1, T.2.2,  P.1  , P.2)
    return (Ax = A1 + A2 + A3)
}
TriArea(x1, y1, x2, y2, x3, y3){
    return Abs((x1 * (y2-y3) + x2 * (y3-y1) + x3 * (y1-y2)) / 2)
}
