use strict;
use warnings;
package Tie::SieveOfEratosthenes;

sub TIEARRAY {
  my $class = shift;
  my @primes = (2,3,5,7);
  return bless \@primes, $class;
}

sub prextend { # Extend the given list of primes using a segment sieve
  my($primes, $to) = @_;
  $to-- unless $to & 1; # Ensure end is odd
  return if $to < $primes->[-1];
  my $sqrtn = int(sqrt($to)+0.001);
  prextend($primes, $sqrtn) if $primes->[-1] < $sqrtn;
  my($segment, $startp) = ('', $primes->[-1]+1);
  my($s_beg, $s_len) = ($startp >> 1, ($to>>1) - ($startp>>1));
  for my $p (@$primes) {
    last if $p > $sqrtn;
    if ($p >= 3) {
      my $p2 = $p*$p;
      if ($p2 < $startp) {   # Bump up to next odd multiple of p >= startp
        my $f = 1+int(($startp-1)/$p);
        $p2 = $p * ($f | 1);
      }
      for (my $s = ($p2>>1)-$s_beg; $s <= $s_len; $s += $p) {
        vec($segment, $s, 1) = 1;   # Mark composites in segment
      }
    }
  }
  # Now add all the primes found in the segment to the list
  do { push @$primes, 1+2*($_+$s_beg) if !vec($segment,$_,1) } for 0 .. $s_len;
}

sub FETCHSIZE { 0x7FFF_FFFF }  # Allows foreach to work
sub FETCH {
  my($primes, $n) = @_;
  return if $n < 0;
  # Keep expanding the list as necessary, 5% larger each time.
  prextend($primes, 1000+int(1.05*$primes->[-1])) while $n > $#$primes;
  return $primes->[$n];
}

if( !caller ) {
  tie my @prime_list, 'Tie::SieveOfEratosthenes';
  my $limit = $ARGV[0] || 100;
  print $prime_list[0];
  my $i = 1;
  while ($prime_list[$i] < $limit) { print " ", $prime_list[$i++]; }
  print "\n";
}

1;
