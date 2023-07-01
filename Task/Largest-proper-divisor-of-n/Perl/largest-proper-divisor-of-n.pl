use strict;
use warnings;
use ntheory 'divisors';
use List::AllUtils <max natatime>;

sub proper_divisors {
  my $n = shift;
  return 1 if $n == 0;
  my @d = divisors($n);
  pop @d;
  @d;
}

my @range = 1 .. 100;
print "GPD for $range[0] through $range[-1]:\n";
my $iter = natatime 10, @range;
while( my @batch = $iter->() ) {
    printf '%3d', $_ == 1 ? 1 : max proper_divisors($_) for @batch; print "\n";
}
