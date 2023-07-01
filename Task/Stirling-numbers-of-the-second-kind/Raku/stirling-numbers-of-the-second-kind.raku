sub Stirling2 (Int \n, Int \k) {
    ((1,), { (0, |@^last) »+« (|(@^last »*« @^last.keys), 0) } … *)[n;k]
}

my $upto = 12;

my $mx = (1..^$upto).map( { Stirling2($upto, $_) } ).max.chars;

put 'Stirling numbers of the second kind: S2(n, k):';
put 'n\k', (0..$upto)».fmt: "%{$mx}d";

for 0..$upto -> $row {
    $row.fmt('%-3d').print;
    put (0..$row).map( { Stirling2($row, $_) } )».fmt: "%{$mx}d";
}

say "\nMaximum value from the S2(100, *) row:";
say (^100).map( { Stirling2 100, $_ } ).max;
