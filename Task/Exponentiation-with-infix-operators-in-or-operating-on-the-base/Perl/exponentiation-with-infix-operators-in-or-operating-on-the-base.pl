use strict;
use warnings;
use Sub::Infix;

BEGIN { *e = infix { $_[0] ** $_[1] } }; # operator needs to be defined at compile time

my @eqns = ('1 + -$xOP$p', '1 + (-$x)OP$p', '1 + (-($x)OP$p)', '(1 + -$x)OP$p', '1 + -($xOP$p)');

for my $op ('**', '/e/', '|e|') {
    for ( [-5, 2], [-5, 3], [5, 2], [5, 3] ) {
        my( $x, $p, $eqn ) = @$_;
        printf 'x: %2d p: %2d |', $x, $p;
        $eqn = s/OP/$op/gr and printf '%17s %4d |', $eqn, eval $eqn for @eqns;
        print "\n";
    }
    print "\n";
}
