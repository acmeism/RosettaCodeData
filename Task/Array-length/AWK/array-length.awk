# usage:  awk -f arraylen.awk
#
function countElements(array) {
  for( e in array ) {c++}
  return c
}

BEGIN {
  array[1] = "apple"
  array[2] = "orange"

  print "Array length :", length(array), countElements(array)

  print "String length:", array[1], length(array[1])
}
