x = int(raw_input("Number 1: "))
y = int(raw_input("Number 2: "))

print "Sum: %d" % (x + y)
print "Difference: %d" % (x - y)
print "Product: %d" % (x * y)
print "Quotient: %d" % (x / y)     #  or x // y  for newer python versions.
                                   # truncates towards negative infinity
print "Remainder: %d" % (x % y)    # same sign as second operand
print "Quotient: %d with Remainder: %d" % divmod(x, y)
print "Power: %d" % x**y

## Only used to keep the display up when the program ends
raw_input( )
