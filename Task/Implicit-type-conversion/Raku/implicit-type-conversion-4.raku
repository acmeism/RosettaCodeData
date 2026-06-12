my $x;
$x = (-1).sqrt;           say $x, ' ', $x.WHAT; # NaN (Num)
$x = (-1).Complex.sqrt;   say $x, ' ', $x.WHAT; # 6.12323399573677e-17+1i (Complex)

$x = (22/7) * 2;          say $x, ' ', $x.WHAT; # 6.285714 (Rat)
$x /= 10**10;             say $x, ' ', $x.WHAT; # 0.000000000629 (Rat)
$x /= 10**10;             say $x, ' ', $x.WHAT; # 6.28571428571429e-20 (Num)

$x = (22/7).FatRat * 2;   say $x, ' ', $x.WHAT; # 6.285714 (FatRat)
$x /= 10**10;             say $x, ' ', $x.WHAT; # 0.000000000629 (FatRat)
$x /= 10**10;             say $x, ' ', $x.WHAT; # 0.0000000000000000000629 (FatRat)
