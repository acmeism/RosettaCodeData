BEGIN {
  a = "a string"
  b = a
  sub(/a/, "X", a) # modify a
  print b  # b is a copy, not a reference to...
}
