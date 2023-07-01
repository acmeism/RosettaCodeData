ClosestPair(points){
	if (points.count() <= 3)
		return bruteForceClosestPair(points)
	split := xSplit(Points)
	LP := split.1			; left points
	LD := ClosestPair(LP)		; recursion : left closest pair
	RP := split.2			; right points
	RD := ClosestPair(RP)		; recursion : right closest pair
	minD := min(LD, RD)		; minimum of LD & RD
	xmin := Split.3 - minD		; strip left boundary
	xmax := Split.3 + minD		; strip right boundary
	S := strip(points, xmin, xmax)
	if (s.count()>=2)
	{
		SD := ClosestPair(S)	; recursion : strip closest pair
		return min(SD, minD)
	}
	return minD
}
;---------------------------------------------------------------
strip(points, xmin, xmax){
	strip:=[]
	for i, coord in points
		if (coord.1 >= xmin) && (coord.1 <= xmax)
			strip.push([coord.1, coord.2])
	return strip
}
;---------------------------------------------------------------
bruteForceClosestPair(points){
	minD := []
	loop, % points.count()-1{
		p1 := points.RemoveAt(1)
		loop, % points.count(){
			p2 := points[A_Index]
			d := dist(p1, p2)
			minD.push(d)
		}
	}
	return min(minD*)
}
;---------------------------------------------------------------
dist(p1, p2){
	return Sqrt((p2.1-p1.1)**2 + (p2.2-p1.2)**2)
}
;---------------------------------------------------------------
xSplit(Points){
	xL := [], xR := []
	p := xSort(Points)
	Loop % Ceil(p.count()/2)
		xL.push(p.RemoveAt(1))
	while p.count()
		xR.push(p.RemoveAt(1))
	mid := (xL[xl.count(),1] + xR[1,1])/2
	return [xL, xR, mid]
}
;---------------------------------------------------------------
xSort(Points){
	S := [], Res :=[]
	for i, coord in points
		S[coord.1, coord.2] := true
	for x, coord in S
		for y, v in coord
			res.push([x, y])
	return res
}
;---------------------------------------------------------------
