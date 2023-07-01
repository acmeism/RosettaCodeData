# convert a matrix of mixed real/complex entries to all complex entries
def to_complex:
  def toc: if type == "number" then [.,0] else . end;
  map( map(toc) );

# simple matrix pretty-printer
def pp(wide):
  def pad: tostring | (wide - length) * " " + .;
  def row: reduce .[] as $x (""; . + ($x|pad));
  reduce .[] as $row (""; . + "\n\($row|row)");

# Matrix multiplication
# A and B should both be real/complex matrices,
# A being m by n, and B being n by p.
def matrix_multiply(A; B):
  A as $A | B as $B
  | ($B[0]|length) as $p
  | ($B|transpose) as $BT
  | reduce range(0; $A|length) as $i
       ([]; reduce range(0; $p) as $j
         (.; .[$i][$j] = dot_product( $A[$i]; $BT[$j] ) )) ;

# Complex identity matrix of dimension n
def complex_identity(n):
  def indicator(i;n):  [range(0;n)] | map( [0,0]) | .[i] = [1,0];
  reduce range(0; n) as $i ([]; . + [indicator( $i; n )] );

# Approximate equality of two matrices
# Are two real/complex matrices essentially equal
# in the sense that the sum of the squared element-wise differences
# is less than or equal to epsilon?
# The two matrices must be conformal.
def approximately_equal(M; N; epsilon):
  def norm: multiply(. ; conjugate ) | .[0];
  def sqdiff( x; y): plus(x; multiply(y; -1)) | norm;
  reduce range(0;M|length) as $i
    (0;  reduce range(0; M[0]|length) as $j
      (.; 0 + sqdiff( M[$i][$j]; N[$i][$j] ) ) ) <= epsilon;
