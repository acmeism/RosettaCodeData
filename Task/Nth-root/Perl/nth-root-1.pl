use strict;

sub nthroot ($$)
{
    my ( $n, $A ) = @_;

    my $x0 = $A / $n;
    my $m = $n - 1.0;
    while(1) {
	my $x1 = ($m * $x0 + $A / ($x0 ** $m)) / $n;
	return $x1 if abs($x1 - $x0) < abs($x0 * 1e-9);
	$x0 = $x1;
    }
}
