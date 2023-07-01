   binomialExpansion&.> i. 8   NB.  2) show the polynomial expansions p in the range 0 to at 7 inclusive.
+-++--+----+-------+-----------+---------------+------------------+
|0||_2|_3 3|_4 6 _4|_5 10 _10 5|_6 15 _20 15 _6|_7 21 _35 35 _21 7|
+-++--+----+-------+-----------+---------------+------------------+
   (#~ testAKS&> ) 2+i. 35     NB. 4) Generate a list of all primes under 35.
2 3 5 7 11 13 17 19 23 29 31
   (#~ testAKS&> ) 2+i. 50     NB. 5) [stretch] Generate all primes under 50
2 3 5 7 11 13 17 19 23 29 31 37 41 43 47
   i.&.:(_1&p:) 50             NB. Double-check our results using built-in prime filter.
2 3 5 7 11 13 17 19 23 29 31 37 41 43 47
