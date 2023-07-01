def binary_digits:
  [ recurse( ./2 | floor; . > 0) % 2 ] | reverse | join("") ;

# The task:
(5, 50, 9000) | binary_digits
