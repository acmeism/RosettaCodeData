# Create an m x n matrix
def matrix(m; n; init):
  if m == 0 then []
  elif m == 1 then [range(0;n)] | map(init)
  elif m > 0 then
    matrix(1;n;init) as $row
    | [range(0;m)] | map( $row )
  else error("matrix\(m);_;_) invalid")
  end ;

def I(n): matrix(n;n;0) as $m
  | reduce range(0;n) as $i ($m; . | setpath( [$i,$i]; 1));

def dot_product(a; b):
  reduce range(0;a|length) as $i (0; . + (a[$i] * b[$i]) );

# transpose/0 expects its input to be a rectangular matrix
def transpose:
  if (.[0] | length) == 0 then []
  else [map(.[0])] + (map(.[1:]) | transpose)
  end ;

# A and B should both be numeric matrices, A being m by n, and B being n by p.
def multiply(A; B):
  (B[0]|length) as $p
  | (B|transpose) as $BT
  | reduce range(0; A|length) as $i
       ([];
       reduce range(0; $p) as $j
         (.;
          .[$i][$j] = dot_product( A[$i]; $BT[$j] ) ));

def swap_rows(i;j):
  if i == j then .
  else .[i] as $i | .[i] = .[j] | .[j] = $i
  end ;

# Print a matrix neatly, each cell occupying n spaces, but without truncation
def neatly(n):
  def right: tostring | ( " " * (n-length) + .);
  . as $in
  | length as $length
  | reduce range (0;$length) as $i
      (""; . + reduce range(0;$length) as $j
      (""; "\(.) \($in[$i][$j] | right )" ) + "\n" ) ;
