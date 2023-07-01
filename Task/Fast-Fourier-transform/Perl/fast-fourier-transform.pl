use strict;
use warnings;
use Math::Complex;

sub fft {
    return @_ if @_ == 1;
    my @evn = fft(@_[grep { not $_ % 2 } 0 .. $#_ ]);
    my @odd = fft(@_[grep { $_ % 2 } 1 .. $#_ ]);
    my $twd = 2*i* pi / @_;
    $odd[$_] *= exp( $_ * -$twd ) for 0 .. $#odd;
    return
    (map { $evn[$_] + $odd[$_] } 0 .. $#evn ),
    (map { $evn[$_] - $odd[$_] } 0 .. $#evn );
}

print "$_\n" for fft qw(1 1 1 1 0 0 0 0);
