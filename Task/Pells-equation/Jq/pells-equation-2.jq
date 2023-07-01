def solvePell:
  . as $n
  | ($n|isqrt) as $x
  | { $x,
     y : $x,
     z : 1,
     r : ($x * 2),
     v1 : 1,
     v2 : 0,
     f1 : 0,
     f2 : 1 }
  | until(.emit;
      .y = .r*.z - .y
      | .z = idivide($n - .y*.y; .z)
      | .r = idivide(.x + .y; .z)
      | .v1 as $t
      | .v1 = .v2
      | .v2 = .r*.v2 + $t
      | .f1 as $t
      | .f1 = .f2
      | .f2 = .r*.f2 + $t
      | (.v2 + .x*.f2) as $a
      | .f2 as $b
      | if ($a*$a - $n*$b*$b == 1) then .emit = [$a, $b] else . end
    ).emit ;

(61, 109, 181, 277)
| solvePell as $res
| "x² - \(.)y² = 1 for x = \($res[0]) and y = \($res[1])"
