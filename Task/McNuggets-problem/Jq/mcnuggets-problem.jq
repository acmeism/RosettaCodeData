[
 [range(18) as $n6  |
  range(13) as $n9  |
  range(6)  as $n20 |
  ($n6 * 6 + $n9 * 9 + $n20 * 20)] |
 unique |
 . as $possible |
 range(101) |
 . as $n |
 select($possible|contains([$n])|not)
] |
max
