arclength(r, angle1, angle2) =  (360 - abs(angle2 - angle1)) * π/180 * r
@show arclength(10, 10, 120)   # -->  arclength(10, 10, 120) = 43.63323129985823
