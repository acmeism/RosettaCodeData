function foo(j  k) {
  # j is an argument passed from caller
  # k is a dummy not passed by caller, but because it is in the
  # argument list, it will have a scope local to the function
  k = length(j)
  print j "contains " k " characters"
}
