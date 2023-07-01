def task1:
  "N                               Integer Portion  Pow  Nth Term",
  ("-" * 89),
  (range(0;10) | almkvistGiullera(true)) ;

def task2($precision):
  r(1; 10 | power($precision)) as $p
  | {sum: r(0;1), prev: r(0;1), n:  0 }
  | until(.stop;
    .sum = radd(.sum; .n | almkvistGiullera(false))
    | if rminus(.sum; .prev) | rabs | rlessthan($p)
      then .stop = true
      else .prev = .sum
      | .n += 1
      end)
   | .sum | rinv
   | rsqrt($precision)
   | "\nPi to \($precision) decimal places is:",
    "\(r_to_decimal($precision))" ;

task1,
""
task2(70)
