constant @factorial = 1, |[\*] 1..*;

sub Lah (Int \n, Int \k) {
    return @factorial[n] if k == 1;
    return 1 if k == n;
    return 0 if k > n;
    return 0 if k < 1 or n < 1;
    (@factorial[n] * @factorial[n - 1]) / (@factorial[k] * @factorial[k - 1]) / @factorial[n - k]
}

my $upto = 12;

my $mx = (1..$upto).map( { Lah($upto, $_) } ).max.chars;

put 'Unsigned Lah numbers:  L(n, k):';
put 'n\k', (0..$upto)».fmt: "%{$mx}d";

for 0..$upto -> $row {
    $row.fmt('%-3d').print;
    put (0..$row).map( { Lah($row, $_) } )».fmt: "%{$mx}d";
}

say "\nMaximum value from the L(100, *) row:";
say (^100).map( { Lah 100, $_ } ).max;
