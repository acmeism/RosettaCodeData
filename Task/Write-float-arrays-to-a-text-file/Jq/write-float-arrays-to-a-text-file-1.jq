[1, 2, 3, 1e11] as $x
| $x | map(sqrt) as $y
| range(0; $x|length) as $i
| "\($x[$i])  \($y[$i])"
