function foo(s,  k) {
  # s is an argument passed from caller
  # k is a dummy not passed by caller, but because it is
  # in the argument list, it will have a scope local to the function
  k = length(s)
  print "'" s "' contains", k, "characters"
}
BEGIN {
  k = 42
  s = "Test"
  foo("Demo")
  print "k is still", k
  foo(s,k)
  print "k still is", k
}
