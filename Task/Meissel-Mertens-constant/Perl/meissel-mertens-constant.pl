use v5.36;
use ntheory qw(forprimes);

my $s;
forprimes { $s += log(1 - 1/$_)+1/$_ } 1e9;
say my $result = $s + .57721566490153286;
