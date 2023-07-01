   NB. factor count is the product of the incremented powers of prime factors
   factor_count =: [: */ [: >: _&q:

   NB. N are the integers 1 to 10000
   NB. FC are the corresponding factor counts
   FC =: factor_count&> N=: >: i. 10000

   NB. take from the integers N{~
   NB. the indexes of truth   I.
   NB. the vector which doesn't equal itself when rotated by one position  (~: _1&|.)
   NB. where that vector is the maximum over all prefixes of the factor counts  >./\FC
   N{~I.(~: _1&|.)>./\FC
1 2 4 6 12 24 36 48 60 120 180 240 360 720 840 1260 1680 2520 5040 7560
