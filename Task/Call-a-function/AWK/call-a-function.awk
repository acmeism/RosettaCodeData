BEGIN {
  sayhello()       # Call a function with no parameters in statement context
  b=squareit(3)    # Obtain the return value from a function with a single parameter in first class context
}
