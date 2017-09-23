def identity(n):
  reduce range(0;n) as $i
    (0 | matrix(n;n); .[$i][$i] = 1);
