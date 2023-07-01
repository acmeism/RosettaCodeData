def task:
  "First 35 unprimeables: ",
  [limit(35; range(0;infinite) | select(is_unprimeable))],

  "\nThe 600th unprimeable is \( nth(600 - 1; unprimeables) ).",

  "\nDigit  First unprimeable ending with that digit",
    "-----------------------------------------------",
  (range(0;10) as $dig
   | first( range(0;infinite) | select((. % 10 == $dig) and is_unprimeable))
   | "  \($dig)  \(lpad(9))" )
 ;

task
