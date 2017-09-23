def fib_binet(n):
  (5|sqrt) as $rt
  | ((1 + $rt)/2) as $phi
  | (($phi | log) * n | exp) as $phin
  | (if 0 == (n % 2) then 1 else -1 end) as $sign
  | ( ($phin - ($sign / $phin) ) / $rt ) + .5
  | floor;
