use Prime::Factor;

constant @fib := 1,1,*+*…*;

my %cache;

multi pisano-period (Int $p where *.is-prime, Int $k where * > 0 = 1) {
    return %cache{"$p|$k"} if %cache{"$p|$k"};
    my $fibmod = @fib.map: * % $p**$k;
    %cache{"$p|$k"} = (1..*).first: { !$fibmod[$_-1] and ($fibmod[$_] == 1) }
}

multi pisano-period (Int $p where * > 0 ) {
    [lcm] prime-factors($p).Bag.map: { samewith .key, .value }
}


put "Pisano period (p, 2) for primes less than 50";
put (map { pisano-period($_, 2) }, ^50 .grep: *.is-prime )».fmt('%4d');

put "\nPisano period (p, 1) for primes less than 180";
.put for (map { pisano-period($_, 1) }, ^180 .grep: *.is-prime )».fmt('%4d').batch(15);

put "\nPisano period (p, 1) for integers 1 to 180";
.put for (1..180).map( { pisano-period($_) } )».fmt('%4d').batch(15);
