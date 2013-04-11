# remember that <(x-<x>)²> = <x²> - <x>²
sub stddev($x) {
    sqrt
        (.[2] += $x**2) / ++.[0] -
        ((.[1] += $x) / .[0])**2
    given state @;
}

say stddev $_ for <2 4 4 4 5 5 7 9>;
