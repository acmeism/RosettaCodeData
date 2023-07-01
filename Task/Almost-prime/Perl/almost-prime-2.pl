use strict;
use warnings;

sub k_almost_prime;

for my $k ( 1 .. 5 ) {
	my $almost = 0;
	print join(", ", map {
		1 until k_almost_prime ++$almost, $k;
		"$almost";
	} 1 .. 10), "\n";
}

sub nth_prime;

sub k_almost_prime {
	my ($n, $k) = @_;
	return if $n <= 1 or $k < 1;
	my $which_prime = 0;
	for my $count ( 1 .. $k ) {
		while( $n % nth_prime $which_prime ) {
			++$which_prime;
		}
		$n /= nth_prime $which_prime;
		return if $n == 1 and $count != $k;
	}
	($n == 1) ? 1 : ();
}

BEGIN {
	# This is loosely based on one of the python solutions
	# to the RC Sieve of Eratosthenes task.
	my @primes = (2, 3, 5, 7);
	my $p_iter = 1;
	my $p = $primes[$p_iter];
	my $q = $p*$p;
	my %sieve;
	my $candidate = $primes[-1] + 2;
	sub nth_prime {
		my $n = shift;
		return if $n < 0;
		OUTER: while( $#primes < $n ) {
			while( my $s = delete $sieve{$candidate} ) {
				my $next = $s + $candidate;
				$next += $s while exists $sieve{$next};
				$sieve{$next} = $s;
				$candidate += 2;
			}
			while( $candidate < $q ) {
				push @primes, $candidate;
				$candidate += 2;
				next OUTER if exists $sieve{$candidate};
			}
			my $twop = 2 * $p;
			my $next = $q + $twop;
			$next += $twop while exists $sieve{$next};
			$sieve{$next} = $twop;
			$p = $primes[++$p_iter];
			$q = $p * $p;	
			$candidate += 2;
		}
		return $primes[$n];
	}
}
