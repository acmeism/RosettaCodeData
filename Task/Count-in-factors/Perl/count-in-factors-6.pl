#!perl -C
use utf8;
use strict;
use warnings;

my $limit = 1000;

print "$_ = $_\n" for 1..3;

my @p_and_sq = ( [2, 4], [3, 9] );

N: for my $n ( 4 .. 1000 ) {
	print $n, " = ";
	for( my $i = 0; $i <= $#p_and_sq; ++$i ) {
		my ($p, $sq) = @{ $p_and_sq[$i] };
		if( $sq > $n ) {
			print $n, "\n";
			push @p_and_sq, [ $n, $n*$n ];
			next N;
		}
		while( 0 == ($n % $p) ) {
			print $p;
			$n /= $p;
			if( $n == 1 ) {
				print "\n";
				next N;
			}
			print " × ";
		}
	}
	die "Ran out of primes?!";
}
