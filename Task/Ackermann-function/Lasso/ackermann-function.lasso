#!/usr/bin/lasso9

define ackermann(m::integer, n::integer) => {
  if(#m == 0) => {
    return ++#n
  else(#n == 0)
    return ackermann(--#m, 1)
  else
    return ackermann(#m-1, ackermann(#m, --#n))
  }
}

with x in generateSeries(1,3),
     y in generateSeries(0,8,2)
do stdoutnl(#x+', '#y+': ' + ackermann(#x, #y))
