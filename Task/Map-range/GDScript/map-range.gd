func mapRange(s:float, a1:float, a2:float, b1:float, b2:float) -> float :
  return b1 + ((b2-b1)/(a2-a1))*(s-a1)

for i in 11 :
  print( "%2d %+.1f" % [i,mapRange(i,0.0,10.0,-1.0,0.0)] )
