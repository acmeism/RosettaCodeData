sub eratsieve($n) {
    # Requires n(1 - 1/(log(n-1))) storage
    my $multiples = set();
    gather for 2..$n -> $i {
        unless $i (&) $multiples { # is subset
            take $i;
            $multiples (+)= set($i**2, *+$i ... (* > $n)); # union
        }
    }
}

say flat eratsieve(100);
