use Math::Prime::Util qw/forprimes/;
use Math::Prime::Util::PrimeArray;
tie my @primes, 'Math::Prime::Util::PrimeArray';

say "First 20: @primes[0..19]";  # Slice from the tied array
print "Between 100 and 150: ";  forprimes { print " $_"; } 100,150;  print "\n";
# Count with forprimes
my $c = 0;
forprimes { $c++ } 7700,8000;
print "$c primes between 7700 and 8000\n";
# The tied array tries to do the right thing -- sieve a window if it sees
# forward or backward iteration, and nth_prime if it looks like random access.
say "${_}th prime: ", $primes[$_-1] for map { 10**$_ } 1..8;
