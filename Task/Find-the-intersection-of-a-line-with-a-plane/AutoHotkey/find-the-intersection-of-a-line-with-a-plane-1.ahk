/*
; https://en.wikipedia.org/wiki/Line%E2%80%93plane_intersection#Algebraic_form
l	= line vector
lo	= point on the line
n	= plane normal vector
Po	= point on the plane

if (l . n) = 0						; line and plane are parallel.
if (Po - lo) . n = 0					; line is contained in the plane.

(P - Po) . n = 0					; vector equation of plane.
P = lo + l * d						; vector equation of line.
((lo + l * d) - Po) . n = 0				; Substitute line into plane equation.
(l . n) * d + (lo - Po) . n = 0				; Expanding.
d = ((Po - lo) . n) / (l . n)				; solving for d.
P = lo + l * ((Po - lo) . n) / (l . n)			; solving P.
*/

intersectPoint(l, lo, n, Pn ){
	if (Vector_dot(Vector_sub(Pn, lo), n) = 0)	; line is contained in the plane
		return [1]
	if (Vector_dot(l, n) = 0)			; line and plane are parallel
		return [0]
    diff  := Vector_Sub(Pn, lo)				; (Po - lo)
    prod1 := Vector_Dot(diff, n)			; ((Po - lo) . n)
    prod2 := Vector_Dot(l, n)				; (l . n)
    d := prod1 / prod2					; d = ((Po - lo) . n) / (l . n)
    return Vector_Add(lo, Vector_Mul(l, d))		; P = lo + l * d
}

Vector_Add(v, w){
    return [v.1+w.1, v.2+w.2, v.3+w.3]
}
Vector_Sub(v, w){
    return [v.1-w.1, v.2-w.2, v.3-w.3]
}
Vector_Mul(v, s){
    return [s*v.1, s*v.2, s*v.3]
}
Vector_Dot(v, w){
    return v.1*w.1 + v.2*w.2 + v.3*w.3
}
