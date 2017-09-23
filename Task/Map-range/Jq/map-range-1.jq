# The input is the value to be mapped.
# The ranges, a and b, should each be an array defining the
# left-most and right-most points of the range.
def maprange(a; b):
  b[0] + (((. - a[0]) * (b[1] - b[0])) / (a[1] - a[0])) ;
