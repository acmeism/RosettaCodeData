use ntheory qw/fromdigits todigitstring/;
my $n   = 65261;
my $n16 = todigitstring($n, 16) || 0;
my $n10 = fromdigits($n16, 16);
say "$n $n16 $n10";  # prints "65261 feed 65261"
