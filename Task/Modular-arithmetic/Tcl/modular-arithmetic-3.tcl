set compiled [$comp compile {$x**100 + $x + 1}]
set x 10
puts "[eval $compiled] = $compiled"
