use strict;
use warnings;
use feature 'say';

sub f {
    my($n) = @_;
    $n % $_ or return $_, f($n/$_) for 2..$n
}

say +(f 600851475143)[-2]
