range(1;1000/3) as $a
| range($a+1;1000/2) as $b
| (1000 - $a - $b) as $c
| select($a*$a + $b*$b == $c*$c)
| {$a, $b, $c, product: ($a*$b*$c)}}
