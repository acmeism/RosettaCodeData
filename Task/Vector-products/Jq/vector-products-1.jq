def dot_product(a; b):
  reduce range(0;a|length) as $i (0; . + (a[$i] * b[$i]) );

# for 3d vectors
def cross_product(a;b):
  [ a[1]*b[2] - a[2]*b[1], a[2]*b[0] - a[0]*b[2], a[0]*b[1]-a[1]*b[0] ];

def scalar_triple_product(a;b;c):
  dot_product(a; cross_product(b; c));

def vector_triple_product(a;b;c):
  cross_product(a; cross_product(b; c));

def main:
  [3, 4, 5] as $a
  | [4, 3, 5] as $b
  | [-5, -12, -13] as $c
  | "a . b = \(dot_product($a; $b))",
    "a x b = [\( cross_product($a; $b) | map(tostring) | join (", ") )]" ,
    "a . (b x c) = \( scalar_triple_product ($a; $b; $c)) )",
    "a x (b x c) = [\( vector_triple_product($a; $b; $c)|map(tostring)|join (", ") )]" ;
