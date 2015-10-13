use strict;
use warnings;
use Math::BigInt;

use constant two => Math::BigInt->new(2);

sub ack {
	my $n = pop;
	while( @_ ) {
		my $m = pop;
		if( $m > 3 ) {
			push @_, (--$m) x $n;
			push @_, reverse 3 .. --$m;
			$n = 13;
		} elsif( $m == 3 ) {
			if( $n < 29 ) {
				$n = ( 1 << ( $n + 3 ) ) - 3;
			} else {
				$n = two ** ( $n + 3 ) - 3;
			}
		} elsif( $m == 2 ) {
			$n = 2 * $n + 3;
		} elsif( $m >= 0 ) {
			$n = $n + $m + 1;
		} else {
			die "negative m!";
		}
	}
	$n;
}

print "ack(3,4) is ", ack(3,4), "\n";
print "ack(4,1) is ", ack(4,1), "\n";
print "ack(4,2) has ", length(ack(4,2)), " digits\n";
