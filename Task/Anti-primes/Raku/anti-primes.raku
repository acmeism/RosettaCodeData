sub propdiv (\x) {
    my @l = 1 if x > 1;
    (2 .. x.sqrt.floor).map: -> \d {
        unless x % d { @l.push: d; my \y = x div d; @l.push: y if y != d }
    }
    @l
}

my $last = 0;

my @anti-primes = lazy 1, |(|(2..59), 60, *+60 … *).grep: -> $c {
    my \mx = +propdiv($c);
    next if mx <= $last;
    $last = mx;
    $c
}

my $upto = 5e5;

put "First 20 anti-primes:\n{ @anti-primes[^20] }";

put "\nCount of anti-primes <= $upto: {+@anti-primes[^(@anti-primes.first: * > $upto, :k)]}";
