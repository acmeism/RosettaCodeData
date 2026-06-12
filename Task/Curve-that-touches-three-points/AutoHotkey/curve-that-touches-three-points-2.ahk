P1 := [10,10], P2 := [100,200], P3 := [200,10]
v := QuadraticCurve(p1,p2,p3)
a := v.1, b:= v.2, c:= v.3
for i, X in [10,100,200]{
	Y := a*X**2 + b*X + c	; Y = aX^2 + bX + c
	res .= "[" x ", " y "]`n"
}
MsgBox % "Y = " a " X^2 " (b>0?"+":"") b " X " (c>0?"+":"") c " `n" res
