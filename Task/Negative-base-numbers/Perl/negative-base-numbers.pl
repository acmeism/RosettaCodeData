use strict;
use feature 'say';
use POSIX qw(floor);
use ntheory qw/fromdigits todigits/;

sub encode {
    my($n, $b) = @_;
    my @out;
    my $r = 0;

    while ($n) {
        $r = $n % $b;
        $n = floor $n/$b;
        $n += 1, $r -= $b if $r < 0;
        push @out, todigits($r, -$b) || 0;
    }
    join '', reverse @out;
}

sub decode {
    my($s, $b) = @_;
    my $total = 0;
    my $i = 0;
    for my $c (reverse split '', $s) {
        $total += (fromdigits($c, -$b) * $b**$i);
        $i++;
    }
    $total
}

say ' 10 in base  -2: ', encode(10, -2);
say ' 15 in base -10: ', encode(15, -10);
say '146 in base  -3: ', encode(146, -3);
say '';
say  '11110 from base  -2: ', decode("11110", -2);
say  '21102 from base  -3: ', decode("21102", -3);
say  '  195 from base -10: ', decode("195",  -10);
