sub div-count (\x) {
    return 2 if x.is-prime;
    +flat (1 .. x.sqrt.floor).map: -> \d {
        unless x % d { my \y = x div d; y == d ?? y !! (y, d) }
    }
}

constant @divcount = lazy (1..Inf).hyper.map(&div-count);

my $limit = 35;

put "First $limit terms of OEIS:A005179";
put ((1..$limit).map: -> $n {
    $n.is-prime ?? (2 ** ($n - 1)) !! 1 + @divcount.first: * == $n, :k
}).batch(5)>>.fmt("%10d").join: "\n";
