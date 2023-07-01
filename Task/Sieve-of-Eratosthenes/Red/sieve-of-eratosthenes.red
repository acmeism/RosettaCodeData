primes: function [n [integer!]][
   poke prim: make bitset! n 1 true
   r: 2 while [r * r <= n][
      repeat q n / r - 1 [poke prim q + 1 * r true]
      until [not pick prim r: r + 1]
   ]
   collect [repeat i n [if not prim/:i [keep i]]]
]

primes 100
== [2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97]
