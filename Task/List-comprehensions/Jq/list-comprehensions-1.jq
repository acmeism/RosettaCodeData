def triples(n):
  range(1;n+1) as $x | range($x;n+1) as $y | range($y;n+1) as $z
  | select($x*$x + $y*$y == $z*$z)
  | [$x, $y, $z] ;
