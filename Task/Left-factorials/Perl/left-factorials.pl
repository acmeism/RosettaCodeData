#!perl
use 5.010;
use strict;
use warnings;
use bigint;

sub leftfact {
	my ($n) = @_;
	state $cached = 0;
	state $factorial = 1;
	state $leftfact = 0;
	if( $n < $cached ) {
		($cached, $factorial, $leftfact) = (0, 1, 0);
	}
	while( $n > $cached ) {
		$leftfact += $factorial;
		$factorial *= ++$cached;
	}
	return $leftfact;
}

printf "!%d = %s\n", $_, leftfact($_) for 0 .. 10, map $_*10, 2..11;
printf "!%d has %d digits.\n", $_, length leftfact($_) for map $_*1000, 1..10;
