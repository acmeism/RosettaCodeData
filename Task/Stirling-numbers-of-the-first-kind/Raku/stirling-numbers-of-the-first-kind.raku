sub Stirling1 (Int \n, Int \k) {
    return 1 unless n || k;
    return 0 unless n && k;
    state %seen;
    (%seen{"{n - 1}|{k - 1}"} //= Stirling1(n - 1, k - 1)) +
    (n - 1) * (%seen{"{n - 1}|{k}"} //= Stirling1(n - 1, k))
}

my $upto = 12;

my $mx = (1..^$upto).map( { Stirling1($upto, $_) } ).max.chars;

put 'Unsigned Stirling numbers of the first kind: S1(n, k):';
put 'n\k', (0..$upto)».fmt: "%{$mx}d";

for 0..$upto -> $row {
    $row.fmt('%-3d').print;
    put (0..$row).map( { Stirling1($row, $_) } )».fmt: "%{$mx}d";
}

say "\nMaximum value from the S1(100, *) row:";
say (^100).map( { Stirling1 100, $_ } ).max;
