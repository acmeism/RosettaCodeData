tp=: (_2 +/@:= 2 -/\ i.&.(p:inv))"0

NB. i.&.(p:inv) generate a list of primes below the given limit
NB. 2 -/\       pairwise subtract adjacent primes (create a list of differences)
NB. _2 +/@:=    compare these differences to -2, and
NB.             sum up the resulting boolean list (get the number of twin pairs)
