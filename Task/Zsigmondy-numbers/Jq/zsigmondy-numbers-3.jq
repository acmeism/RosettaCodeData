def abs:
  [ [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [3, 2], [5, 3], [7, 3], [7, 5] ];

abs[] as [$a, $b]
| (if ($a == 7 and $b != 3) then 18 else 20 end) as $lim
  | "Zsigmony(\($a), \($b)) - first \($lim) terms:",
     [range(1; $lim+1) | zs($a; $b)]
