sub comma { $^i.flip.comb(3).join(',').flip }

my \k = 2**128;
put "First 10 cuban primes where k = {k}:";
.&comma.put for (lazy (0..Inf).map({ (($_+k)³ - .³)/k }).grep: *.is-prime)[^10];
