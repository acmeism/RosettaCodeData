use strict;
use warnings;
use utf8;
binmode(STDOUT, ':utf8');

sub long_division {
    my($n, $d) = @_;
    my %seen;

    my($numerator,$denominator) = (abs $n, abs $d);
    my $negative = ($n < 0 xor $d < 0) ? '-' : '';

    my $fraction = sprintf '%d.', $numerator / $denominator;
    my $position = length $fraction;
    $numerator %= $denominator;
    while (!$seen{$numerator}) {
        return 0, $fraction =~ s/\.$//r unless $numerator;
        $seen{$numerator} = $position;
        $fraction  .= int 10 * $numerator / $denominator;
        $numerator  =     10 * $numerator % $denominator;
        $position++;
    }

    my $period = length($fraction) - $seen{$numerator};
    substr($fraction, $seen{$numerator}+(2*$_)+1, 0, "\N{COMBINING OVERLINE}") for 0 .. $period-1;
    $period, $negative . $fraction
}

printf "%10s Period is %5d : %s\n", $_, long_division split '/'
    for <0/1 1/1 1/5 1/3 -1/3 1/7 -83/60 1/17 10/13 3227/555 1/149>
