use strict;
use warnings;
use feature qw(say state);

use ntheory      'fromdigits';
use List::Lazy   'lazy_list';
use Math::AnyNum ':overload';

my $calkin_wilf = lazy_list { state @cw = 1; push @cw, 1 / ( (2 * int $cw[0]) + 1 - $cw[0] ); shift @cw };

sub r2cf {
  my($num, $den) = @_;
  my($n, @cf);
  my $f = sub { return unless $den;
               my $q = int($num/$den);
               ($num, $den) = ($den, $num - $q*$den);
               $q;
             };
  push @cf, $n while defined($n = $f->());
  reverse @cf;
}

sub r2cw {
    my($num, $den) = @_;
    my $bits;
    my @f = r2cf($num, $den);
    $bits .= ($_%2 ? 0 : 1) x $f[$_] for 0..$#f;
    fromdigits($bits, 2);
}

say 'First twenty terms of the Calkin-Wilf sequence:';
printf "%s ", $calkin_wilf->next() for 1..20;
say "\n\n83116/51639 is at index: " . r2cw(83116,51639);
