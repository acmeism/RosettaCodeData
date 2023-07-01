   ~.&.q: 1+i.5 10   NB. radicals of first 50 positive integers
 1  2  3  2  5  6  7  2  3 10
11  6 13 14 15  2 17  6 19 10
21 22 23  6  5 26  3 14 29 30
31  2 33 34 35  6 37 38 39 10
41 42 43 22 15 46 47  6  7 10
   ~.&.q: 99999 499999 999999   NB. radicals of these three...
33333 3937 111111
   (~.,.#/.~) 1>.#@~.@q: 1+i.1e6   NB.  distribution of number of prime factors of first million positive integers
1  78735
2 288726
3 379720
4 208034
5  42492
6   2285
7      8
   p:inv 1e6   NB. number of primes not exceeding 1 million
78498
   +/_1+<.(i.&.(p:inv) 1000)^.1e6  NB. count of prime powers (square or above) up to 1 million
236
   78498+236+1   NB. and we "claimed" that 1 had a prime factor
78735
