use strict;
use warnings;
use feature 'say';
use ntheory qw/fromdigits todigitstring/;
use utf8;
binmode('STDOUT', 'utf8');

sub first_square  {
    my $n = shift;
    my $sr = substr('1023456789abcdef',0,$n);
    my $r  = int fromdigits($sr, $n) ** .5;
    my @digits = reverse split '', $sr;
    TRY: while (1) {
        my $sq = $r * $r;
        my $cnt = 0;
        my $s = todigitstring($sq, $n);
        my $i = scalar @digits;
        for (@digits) {
            $r++ and redo TRY if (-1 == index($s, $_)) || ($i-- + $cnt < $n);
            last if $cnt++ == $n;
        }
        return sprintf "Base %2d: %10s² == %s", $n, todigitstring($r, $n),
               todigitstring($sq, $n);
    }
}

say "First perfect square with N unique digits in base N: ";
say first_square($_) for 2..16;
