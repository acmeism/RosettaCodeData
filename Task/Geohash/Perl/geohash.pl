use strict;
use warnings;
use feature 'say';
use List::AllUtils qw<sum max natatime>;

my @Geo32 = <0 1 2 3 4 5 6 7 8 9 b c d e f g h j k m n p q r s t u v w x y z>;

sub geo_encode {
    my( $latitude, $longitude, $precision ) = @_;
    my @coord = ($latitude, $longitude);
    my @range = ([-90, 90], [-180, 180]);
    my($which,$value) = (1, '');
    while (length($value) < $precision * 5) {
        my $mid = sum(@{$range[$which]}) / 2;
        $value .= my $upper = $coord[$which] <= $mid ? 0 : 1;
        $range[$which][$upper ? 0 : 1] = $mid;
        $which = $which ? 0 : 1;
    }
    my $enc;
    my $iterator = natatime 5, split '', $value;
    while (my @n = $iterator->()) {
        $enc .= $Geo32[ord pack 'B8', '000' . join '', @n]; # binary to decimal, very specific to the task
    }
    $enc
}

sub geo_decode {
    my($geo) = @_;
     my @range = ([-90, 90], [-180, 180]);
     my(%Geo32,$c); $Geo32{$_} = $c++ for @Geo32;
     my $which = 1;
     for ( split '', join '', map { sprintf '%05b', $_ } @Geo32{split '', $geo} ) {
        $range[$which][$_] = sum(@{$range[$which]}) / 2;
        $which = $which ? 0 : 1;
     }
     @range
}

for ([51.433718,   -0.214126,  2, 'Ireland, most of England and Wales, small part of Scotland'],
     [51.433718,   -0.214126,  9, "the umpire's chair on Center Court at Wimbledon"],
     [51.433718,   -0.214126, 17, 'likely an individual molecule of the chair'],
     [57.649110,   10.407440, 11, 'Wikipedia test value - Råbjerg Mile in Denmark'],
     [59.115800, -151.687312,  7, 'Perl Island, Alaska'],
     [38.743586, -109.499336,  8, 'Delicate Arch, Utah'],
    ) {
    my($lat, $long, $precision, $description) = @$_;
    my $enc = geo_encode($lat, $long, $precision);
    say "\n$lat, $long, $precision ($description):" .
        "\ngeo-encoded: $enc\n" .
        'geo-decoded: ' . join ',  ',
        map {         sprintf("%.@{[max(3,$precision-3)]}f", (  -($$_[0] + $$_[1]) / 2)) .
              ' ± ' . sprintf('%.3e',                        (abs($$_[0] - $$_[1]) / 2))
            } geo_decode($enc);}
