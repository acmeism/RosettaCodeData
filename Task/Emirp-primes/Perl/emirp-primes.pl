use feature 'say';
use ntheory qw(forprimes is_prime);

# Return the first $count emirps using expanding segments.
# Can efficiently generate millions of emirps.
sub emirp_list {
  my $count = shift;
  my($i, $inc, @n) = (13, 100+10*$count);
  while (@n < $count) {
    forprimes {
      push @n, $_ if is_prime(reverse $_) && $_ ne reverse($_);
    } $i, $i+$inc-1;
    ($i, $inc) = ($i+$inc, int($inc * 1.03) + 1000);
  }
  splice @n, $count;  # Trim off excess emirps
  @n;
}

say "First 20: ", join " ", emirp_list(20);
print "Between 7700 and 8000:";
forprimes { print " $_" if is_prime(reverse $_) && $_ ne reverse($_) } 7700,8000;
print "\n";
say "The 10_000'th emirp: ", (emirp_list(10000))[-1];
