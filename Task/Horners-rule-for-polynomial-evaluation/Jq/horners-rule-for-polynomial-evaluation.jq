# Input: an array of coefficients specifying the polynomial
# to be evaluated at $x, where .[0] is the constant
def horner($x):
  . as $coefficients
  | reduce range(length-1; -1; -1) as $i (0; . * $x + $coefficients[$i]);

# Example
[-19, 7, -4, 6] | horner(3)
