def task:
  "The reduced latin squares of order 4 are:",
  (4 | latin_squares),
  "",
  (range(1; 7)
   | . as $i
   | count(latin_squares) as $c
   | ($c * factorial * ((.-1)|factorial)) as $total
   | "There are \($c) reduced latin squares of order \(.); \($c) * \(.)! * \(.-1)! is \($total)"
  ) ;

task
