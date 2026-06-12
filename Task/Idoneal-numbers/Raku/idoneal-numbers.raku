sub is-idoneal ($n) {
    my $idoneal = True;
    I: for 1 .. $n -> $a {
        for $a ^.. $n -> $b {
            last if $a × $b + $a + $b > $n; # short circuit
            for $b ^.. $n -> $c {
                $idoneal = False and last I if (my $sum = $a × $b + $b × $c + $c × $a) == $n;
                last if $sum > $n; # short circuit
            }
        }
    }
    $idoneal
}

$_».fmt("%4d").put for (1..1850).hyper(:32batch).grep( &is-idoneal ).batch(10)
