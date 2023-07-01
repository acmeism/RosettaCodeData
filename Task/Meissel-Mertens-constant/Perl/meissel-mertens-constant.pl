use v5.36;
use ntheory 'is_prime';

my $s;
is_prime $_ and $s += log(1 - 1/$_)+1/$_ for 2 .. 10**9;
say my $result = $s + .57721566490153286;
