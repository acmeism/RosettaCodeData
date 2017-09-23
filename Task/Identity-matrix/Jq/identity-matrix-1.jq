def identity(n):
  [range(0;n) | 0] as $row
  | reduce range(0;n) as $i ([]; . + [ $row | .[$i] = 1 ] );
