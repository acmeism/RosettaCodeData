use strict;
use List::Util qw(min);

sub poly_long_div
{
    my ($rn, $rd) = @_;

    my @n = @$rn;
    my $gd = scalar(@$rd);
    if ( scalar(@n) >= $gd ) {
	my @q = ();
	while ( scalar(@n) >= $gd ) {
	    my $piv = $n[0]/$rd->[0];
	    push @q, $piv;
	    $n[$_] -= $rd->[$_] * $piv foreach ( 0 .. min(scalar(@n), $gd)-1 );
	    shift @n;
	}
	return ( \@q, \@n );
    } else {
	return ( [0], $rn );
    }
}
