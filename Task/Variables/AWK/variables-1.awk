BEGIN {
# Variables are dynamically typecast, and do not need declaration prior to use:
  fruit = "banana"    # create a variable, and fill it with a string
  a = 1               # create a variable, and fill it with a numeric value
  a = "apple"         # re-use the above variable for a string
  print a, fruit

# Multiple assignments are possible from within a single statement:
  x = y = z = 3
  print "x,y,z:", x,y,z

# "dynamically typecast" means the content of a variable is used
# as needed by the current operation, e.g. for a calculation:
  a = "1"
  b = "2banana"
  c = "3*4"

  print "a,b,c=",a,b,c,  "c+0=", c+0, 0+c
  print "a+b=", a+b, "b+c=", b+c
}
