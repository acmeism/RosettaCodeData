def dot_product(a; b):
  reduce range(0;a|length) as $i (0; . + (a[$i] * b[$i]) );

# A and B should both be numeric matrices, A being m by n, and B being n by p.
def multiply(A; B):
  (B[0]|length) as $p
  | (B|transpose) as $BT
  | reduce range(0; A|length) as $i
       ([];
       reduce range(0; $p) as $j
         (.;
          .[$i][$j] = dot_product( A[$i]; $BT[$j] ) ));
