# 20210616 Perl programming solution

use strict;
use warnings;
use feature 'say';

use Math::Complex;
use constant  PI => 4 * atan2(1, 1);
use constant ESP =>  1e10; # net worth, the imaginary part
use constant EPS => 1e-10; # the reality part

sub dft {
   my $n = scalar ( my @in = @_ );
   return map {
      my $s=0;
      for my $k (0 .. $n-1) { $s += $in[$k] * exp(-2*i * PI * $k * $_ / $n) }
      $_ = $s;
   } (0 .. $n-1);
}

sub idft {
   my $n = scalar ( my @in = @_ );
   return map {
      my $s=0;
      for my $k (0 .. $n-1) { $s += $in[$k] * exp(2*i * PI * $k * $_ / $n) }
      my $t = $s/$n;
      $_ = abs(Im $t) < EPS ? Re($t) : $t
   } (0 .. $n-1);
}

say 'Original sequence                  : ', join ', ', my @series = ( 2, 3, 5, 7, 11 );
say 'Discrete Fourier transform         : ', join ', ', my @dft = dft @series;
say 'Inverse Discrete Fourier Transform : ', join ', ', idft @dft;
