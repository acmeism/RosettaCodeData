CircleCenter(x1, y1, x2, y2, r){
	d := sqrt((x2-x1)**2 + (y2-y1)**2)
	x3 := (x1+x2)/2	, y3 := (y1+y2)/2
	cx1 := x3 + sqrt(r**2-(d/2)**2)*(y1-y2)/d , 	cy1:= y3 + sqrt(r**2-(d/2)**2)*(x2-x1)/d
	cx2 := x3 - sqrt(r**2-(d/2)**2)*(y1-y2)/d , 	cy2:= y3 - sqrt(r**2-(d/2)**2)*(x2-x1)/d
	if (d = 0)
		return "No circles can be drawn, points are identical"
	if (d = r*2)
		return "points are opposite ends of a diameter center = " cx1 "," cy1
	if (d = r*2)
		return "points are too far"
	if (r <= 0)
		return "radius is not valid"
	if !(cx1 && cy1 && cx2 && cy2)
		return "no solution"
	return cx1 "," cy1 " & " cx2 "," cy2
}
