def pow(n):
  . as $x | n as $n
  | reduce range(0;$n) as $i (1; . * $x);
