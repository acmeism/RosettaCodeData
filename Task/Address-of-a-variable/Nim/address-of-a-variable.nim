var x = 12
var xptr = addr(x) # Get address of variable
echo cast[int](xptr) # and print it
xptr = cast[ptr int](0xFFFE) # Set the address
