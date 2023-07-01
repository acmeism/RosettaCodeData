use strict;
use warnings;
package Tie::SieveOfEratosthenes;

sub TIEARRAY {
	my $class = shift;
	bless \$class, $class;
}

# If set to true, produces copious output.  Observing this output
# is an excellent way to gain insight into how the algorithm works.
use constant DEBUG => 0;

# If set to true, causes the code to skip over even numbers,
# improving runtime.  It does not alter the output content, only the speed.
use constant WHEEL2 => 0;

BEGIN {

	# This is loosely based on the Python implementation of this task,
	# specifically the "Infinite generator with a faster algorithm"

	my @primes = (2, 3);
	my $ps = WHEEL2 ? 1 : 0;
	my $p = $primes[$ps];
	my $q = $p*$p;
	my $incr = WHEEL2 ? 2 : 1;
	my $candidate = $primes[-1] + $incr;
	my %sieve;
	
	print "Initial: p = $p, q = $q, candidate = $candidate\n" if DEBUG;

	sub FETCH {
		my $n = pop;
		return if $n < 0;
		return $primes[$n] if $n <= $#primes;
		OUTER: while( 1 ) {

			# each key in %sieve is a composite number between
			# p and p-squared.  Each value in %sieve is $incr x the prime
			# which acted as a 'seed' for that key.  We use the value
			# to step through multiples of the seed-prime, until we find
			# an empty slot in %sieve.
			while( my $s = delete $sieve{$candidate} ) {
				print "$candidate a multiple of ".($s/$incr).";\t\t" if DEBUG;
				my $composite = $candidate + $s;
				$composite += $s while exists $sieve{$composite};
				print "The next stored multiple of ".($s/$incr)." is $composite\n" if DEBUG;
				$sieve{$composite} = $s;
				$candidate += $incr;
			}

			print "Candidate $candidate is not in sieve\n" if DEBUG;

			while( $candidate < $q ) {
				print "$candidate is prime\n" if DEBUG;
				push @primes, $candidate;
				$candidate += $incr;
				next OUTER if exists $sieve{$candidate};
			}

			die "Candidate = $candidate, p = $p, q = $q" if $candidate > $q;
			print "Candidate $candidate is equal to $p squared;\t" if DEBUG;

			# Thus, it is now time to add p to the sieve,
			my $step = $incr * $p;
			my $composite = $q + $step;
			$composite += $step while exists $sieve{$composite};
			print "The next multiple of $p is $composite\n" if DEBUG;
			$sieve{$composite} = $step;
		
			# and fetch out a new value for p from our primes array.
			$p = $primes[++$ps];
			$q = $p * $p;	
			
			# And since $candidate was equal to some prime squared,
			# it's obviously composite, and we need to increment it.
			$candidate += $incr;
			print "p is $p, q is $q, candidate is $candidate\n" if DEBUG;
		} continue {
			return $primes[$n] if $n <= $#primes;
		}
	}

}

if( !caller ) {
	tie my (@prime_list), 'Tie::SieveOfEratosthenes';
	my $limit = $ARGV[0] || 100;
	my $line = "";
	for( my $count = 0; $prime_list[$count] < $limit; ++$count ) {
		$line .= $prime_list[$count]. ", ";
		next if length($line) <= 70;
		if( $line =~ tr/,// > 1 ) {
			$line =~ s/^(.*,) (.*, )/$2/;
			print $1, "\n";
		} else {
			print $line, "\n";
			$line = "";
		}
	}
	$line =~ s/, \z//;
	print $line, "\n" if $line;
}

1;
