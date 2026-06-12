def bidiagonal_matrix:
  . as $n
  | [range(0; $n) | 0] as $z
  | reduce range(0; $n) as $i ([];
      . + [$z | .[$i] = 1 | .[$n-$i-1] = 1] );

def display:
  map(join(" ")) | join("\n");
