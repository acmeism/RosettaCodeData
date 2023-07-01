decimals(8)
see haversine(36.12, -86.67, 33.94, -118.4) + nl

func haversine x1, y1, x2, y2
     r=0.01745
     x1= x1*r
     x2= x2*r
     y1= y1*r
     y2= y2*r
     dy = y2-y1
     dx = x2-x1
     a = pow(sin(dx/2),2) + cos(x1) * cos(x2) * pow(sin(dy/2),2)
     c = 2 * asin(sqrt(a))
     d = 6372.8 * c
     return d
