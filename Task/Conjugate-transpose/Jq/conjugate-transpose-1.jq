# transpose/0 expects its input to be a rectangular matrix
# (an array of equal-length arrays):
def transpose:
  if (.[0] | length) == 0 then []
  else [map(.[0])] + (map(.[1:]) | transpose)
  end ;
