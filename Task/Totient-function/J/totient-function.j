  nth_prime =: p:   NB. 2 is the zeroth prime
   totient =: 5&p:
   primeQ =:  1&p:

   NB. first row contains the integer
   NB. second row             totient
   NB. third                  1 iff prime
   (, totient ,: primeQ) >: i. 25
1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
1 1 2 2 4 2 6 4 6  4 10  4 12  6  8  8 16  6 18  8 12 10 22  8 20
0 1 1 0 1 0 1 0 0  0  1  0  1  0  0  0  1  0  1  0  0  0  1  0  0


   NB. primes first exceeding the limits
   [&.:(p:inv) 10 ^ 2 + i. 4
101 1009 10007 100003

   p:inv 101 1009 10007 100003
25 168 1229 9592

   NB. limit and prime count
   (,. p:inv) 10 ^ 2 + i. 5
   100    25
  1000   168
 10000  1229
100000  9592
   1e6 78498
