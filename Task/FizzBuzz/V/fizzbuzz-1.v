[fizzbuzz
    1 [>=] [
     [[15 % zero?] ['fizzbuzz' puts]
      [5 % zero?]  ['buzz' puts]
      [3 % zero?]  ['fizz' puts]
      [true] [dup puts]
    ] when succ
  ] while].
 |100 fizzbuzz
