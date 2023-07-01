TrianglesIntersect(T1, T2){		; T1 := [[x1,y1],[x2,y2],[x3,y3]]	, T2 :=[[x4,y4],[x5,y5],[x6,y6]]
	counter := 0
	for i, Pt in T1
		counter += PointInTriangle(Pt, T2)	; check if any coordinate of triangle 1 is inside triangle 2
	for i, Pt in T2
		counter += PointInTriangle(Pt, T1)	; check if any coordinate of triangle 2 is inside triangle 1
	; check if sides of triangle 1 intersect with sides of triangle 2
	counter += LinesIntersect([t1.1,t1.2],[t2.1,t2.2]) ? 1 : 0
	counter += LinesIntersect([t1.1,t1.3],[t2.1,t2.2]) ? 1 : 0
	counter += LinesIntersect([t1.2,t1.3],[t2.1,t2.2]) ? 1 : 0
	
	counter += LinesIntersect([t1.1,t1.2],[t2.1,t2.3]) ? 1 : 0
	counter += LinesIntersect([t1.1,t1.3],[t2.1,t2.3]) ? 1 : 0
	counter += LinesIntersect([t1.2,t1.3],[t2.1,t2.3]) ? 1 : 0
	
	counter += LinesIntersect([t1.1,t1.2],[t2.2,t2.3]) ? 1 : 0
	counter += LinesIntersect([t1.1,t1.3],[t2.2,t2.3]) ? 1 : 0
	counter += LinesIntersect([t1.2,t1.3],[t2.2,t2.3]) ? 1 : 0
	return (counter>3) ; 3 points inside or 1 point inside and 2 lines intersect or 3 lines intersect
}
PointInTriangle(pt, Tr){	; pt:=[x,y]	, Tr := [[x1,y1],[x2,y2],[x3,y3]]
	v1 := Tr.1, v2 := Tr.2, v3 := Tr.3
    d1 := sign(pt, v1, v2)
    d2 := sign(pt, v2, v3)
    d3 := sign(pt, v3, v1)
    has_neg := (d1 < 0) || (d2 < 0) || (d3 < 0)
    has_pos := (d1 > 0) || (d2 > 0) || (d3 > 0)
    return !(has_neg && has_pos)
}
sign(p1, p2, p3){
    return (p1.1 - p3.1) * (p2.2 - p3.2) - (p2.1 - p3.1) * (p1.2 - p3.2)
}
LinesIntersect(L1, L2){		; L1 := [[x1,y1],[x2,y2]]	, L2 := [[x3,y3],[x4,y4]]
	x1 := L1[1,1], y1 := L1[1,2]
	x2 := L1[2,1], y2 := L1[2,2]
	x3 := L2[1,1], y3 := L2[1,2]
	x4 := L2[2,1], y4 := L2[2,2]
	x := ((x1*y2-y1*x2)*(x3-x4) - (x1-x2)*(x3*y4-y3*x4)) / ((x1-x2)*(y3-y4) - (y1-y2)*(x3-x4))
	y := ((x1*y2-y1*x2)*(y3-y4) - (y1-y2)*(x3*y4-y3*x4)) / ((x1-x2)*(y3-y4) - (y1-y2)*(x3-x4))
	if (x<>"" && y<>"") && isBetween(x, x1, x2) && isBetween(x, x3, x4) && isBetween(y, y1, y2) && isBetween(y, y3, y4)
		return 1
}
isBetween(x, p1, p2){
	return !((x>p1 && x>p2) || (x<p1 && x<p2))
}
