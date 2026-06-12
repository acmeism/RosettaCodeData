data :=  [[[3, -5], 3,    [-10, 11],    [10, -9],    0]
        , [[3, -5], 3,    [-10, 11],    [-11, 12],    1]
        , [[3, -5], 3,    [3, -2],    [7, -2],    1]
        , [[0, 0],  4,    [0, -3],    [0, 6],     0]
        , [[0, 0],  4,    [0, -3],    [0, 6],        1]
        , [[4, 2],  5,    [6, 3],        [10, 7],    0]
        , [[4, 2],  5,    [7, 4],        [11, 8],    1]]

Result := "Center`tRad`tP1`tP2`tSegment`tintersect 1`tIntersect 2`n"
for i, obj in data
{
    x := Line_circle_intersection(center := obj.1, radius := obj.2, P1 := obj.3, P2 := obj.4, Segment := obj.5)
    Result .= "[" center.1 "," center.2 "]`t" radius "`t[" p1.1 "," p1.2 "]`t[" p2.1 "," p2.2 "]`t" Segment
    for i, v in x
        Result .=  "`t[" i "]"
    Result .= "`n"
}
MsgBox % Result
return

Line_circle_intersection(c, r, p1, p2, segment:=0){
    global result
    p1.1 -= c.1,    p2.1 -= c.1,    p1.2 -= c.2,    p2.2 -= c.2

    dx := p2.1 - p1.1,    dy := p2.2 - p1.2
    dr := Sqrt(dx**2 + dy**2)
    D  := p1.1*p2.2 - p2.1*p1.2
    x1 := (D * dy + sgn(dy) * dx * Sqrt(r**2 * dr**2 - D**2)) / dr**2
    x2 := (D * dy - sgn(dy) * dx * Sqrt(r**2 * dr**2 - D**2)) / dr**2
    y1  := (0-D * dx + Abs(dy) * Sqrt(r**2 * dr**2 - D**2)) / dr**2
    y2  := (0-D * dx - Abs(dy) * Sqrt(r**2 * dr**2 - D**2)) / dr**2

    p1.1 += c.1,    p2.1 += c.1,    p1.2 += c.2,    p2.2 += c.2
    x1 += c.1,    x2 += c.1,    y1 += c.2,    y2 += c.2

    res := []
    if segment
    {
        if !((x1 < p1.1 && x1 < p2.1) || (x1 > p1.1 && x1 > p2.1)
          || (y1 < p1.2 && y1 < p2.2) || (y1 > p1.2 && y1 > p2.2))
            res[x1 ", " y1] := true
        if !((x2 < p1.1 && x2 < p2.1) || (x2 > p1.1 && x2 > p2.1)
          || (y2 < p1.2 && y2 < p2.2) || (y2 > p1.2 && y2 > p2.2))
            res[x2 ", " y2] := true
    }
    else
        res[x1 ", " y1] := true, res[x2 ", " y2] := true
    return res
}
sgn(x){
    return x<0?-1:1
}
