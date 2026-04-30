let n = 24
  1..($n | math sqrt | math floor) |
    where { |$f| $n mod $f == 0 } |
  each { |$f| [$f (($n / $f) | into int) ] } |
  sort | grid -w 80
