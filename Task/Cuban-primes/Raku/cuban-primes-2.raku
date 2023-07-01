sub comma { $^i.flip.comb(3).join(',').flip }

for 2..10 -> \k {
    next if k %% 3;
    my @cubans = lazy (1..Inf).map({ (($_+k)³ - .³)/k }).grep: *.is-prime;
    put "First 20 cuban primes where k = {k}:";
    put @cubans[^20]».&comma».fmt("%7s").rotor(10).join: "\n";
    put '';
}
