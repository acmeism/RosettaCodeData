def waterCollected:
  . as $tower
  | ($tower|length) as $n
  | ([0] + [range(1;$n) | ($tower[0:.]  | max) ]) as $highLeft
  | (      [range(1;$n) | ($tower[.:$n] | max) ] + [0]) as $highRight
  | [ range(0;$n) | [ ([$highLeft[.], $highRight[.] ]| min) - $tower[.], 0 ] | max]
  | add ;

def towers: [
    [1, 5, 3, 7, 2],
    [5, 3, 7, 2, 6, 4, 5, 9, 1, 2],
    [2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1],
    [5, 5, 5, 5],
    [5, 6, 7, 8],
    [8, 7, 7, 6],
    [6, 7, 10, 7, 6]
];

towers[]
| "\(waterCollected) from \(.)"
