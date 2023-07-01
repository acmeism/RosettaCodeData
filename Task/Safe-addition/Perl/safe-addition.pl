use strict;
use warnings;
use Data::IEEE754::Tools <nextUp nextDown>;

sub safe_add {
    my($a,$b) = @_;
    my $c = $a + $b;
    return $c, nextDown($c), nextUp($c)
}

printf "%.17f (%.17f, %.17f)\n", safe_add (1/9,1/7);
