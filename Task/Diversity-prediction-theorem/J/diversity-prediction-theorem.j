echo 'Use: ' , (;:inv 2 {. ARGV) , ' <reference value>  <observations>'

data=: ([: ". [: ;:inv 2&}.) ::([: exit 1:) ARGV

([: exit (1: echo@('insufficient data'"_)))^:(2 > #) data

mean=: +/ % #
variance=: [: mean [: *: -

averageError=: ({. variance }.)@:]
crowdError=:  variance {.
diversity=:  variance }.

echo (<;._2'average error;crowd error;diversity;') ,: ;/ (averageError`crowdError`diversity`:0~ mean@:}.) data

exit 0
