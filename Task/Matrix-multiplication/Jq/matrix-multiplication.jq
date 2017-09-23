def dot_product(a; b):
  a as $a | b as $b
  | reduce range(0;$a|length) as $i (0; . + ($a[$i] * $b[$i]) );

# transpose/0 expects its input to be a rectangular matrix (an array of equal-length arrays)
def transpose:
  if (.[0] | length) == 0 then []
  else [map(.[0])] + (map(.[1:]) | transpose)
  end ;

# A and B should both be numeric matrices, A being m by n, and B being n by p.
def multiply(A; B):
  A as $A | B as $B
  | ($B[0]|length) as $p
  | ($B|transpose) as $BT
  | reduce range(0; $A|length) as $i
       ([]; reduce range(0; $p) as $j
         (.; .[$i][$j] = dot_product( $A[$i]; $BT[$j] ) )) ;
