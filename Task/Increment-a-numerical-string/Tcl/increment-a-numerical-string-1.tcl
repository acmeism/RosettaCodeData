# n is string
set n "1234"
# increments the integer rep to 1235, updates string rep to "1235"
incr n

# integer rep added to n
# o is calculated integer
set val [expr {$n + 1}]

# n is string,
# o used as string adds string representation to o
puts stdout "$n incrememented is $o"
