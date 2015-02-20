use strict;
use warnings;
use Math::Complex;

sub fft {
    return @_ if @_ == 1;
    my @evn = fft(@_[grep { not $_ % 2 } 0 .. $#_ ]);
    my @odd = fft(@_[grep { $_ % 2 } 1 .. $#_ ]);
    my $twd = 2*i* pi / @_;
    $odd[$_] *= exp( $_ * $twd ) for 0 .. $#odd;
    return
    (map { $evn[$_] + $odd[$_] } 0 .. $#evn ),
    (map { $evn[$_] - $odd[$_] } 0 .. $#evn );
}


my @seq    = 0 .. 15;
my $cycles = 3;
my @wave = map { sin( $_ * 2*pi/ @seq * $cycles ) } @seq;
print "wave: ", join " ", map { sprintf "%7.3f", $_ } @wave;
print "\n";
print "fft:  ", join " ", map { sprintf "%7.3f", abs $_ } fft(@wave);
