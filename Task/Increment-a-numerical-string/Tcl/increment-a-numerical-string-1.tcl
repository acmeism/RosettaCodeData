# n is string
set n "1234"

# integer rep added to n
# o is calculated integer
set o [expr $n + 1]

# n is string,
# o used as string adds string representation to o
puts stdout "$n incrememented is $o"
