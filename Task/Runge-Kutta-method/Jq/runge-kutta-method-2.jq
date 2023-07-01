# yprime maps [t,y] to a number, i.e. t * sqrt(y)
def yprime: .[0] * (.[1] | sqrt);

# The exact solution of yprime:
def actual:
  . as $t
  | (( $t*$t) + 4 )
  | . * . / 16;
