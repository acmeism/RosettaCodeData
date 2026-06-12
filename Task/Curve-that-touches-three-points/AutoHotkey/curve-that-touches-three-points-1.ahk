QuadraticCurve(p1,p2,p3){ ; Y = aX^2 + bX + c
	x1:=p1.1, y1:=p1.2, x2:=p2.1, y2:=p2.2, x3:=p3.1, y3:=p3.2
	m:=x1-x2, n:=x3-x2, m:= ((m*n)<0?-1:1) * m
	a:=(n*(y1-y2)+m*(y3-y2)) / (n*(x1**2 - x2**2) + m*(x3**2 - x2**2))
	b:=((y3-y2) - (x3**2 - x2**2)*a) / (x3-x2)
	c:=y1 - a*x1**2 - b*x1
	return [a,b,c]
}
