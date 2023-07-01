use strict;
use warnings;
use List::Util qw(min max);

sub jaro {
    my($s, $t) = @_;
    my(@s_matches, @t_matches, $matches);

    return 1 if $s eq $t;

    my($s_len, @s) = (length $s, split //, $s);
    my($t_len, @t) = (length $t, split //, $t);

    my $match_distance = int (max($s_len, $t_len) / 2) - 1;
    for my $i (0 .. $#s) {
        my $start = max(0, $i - $match_distance);
        my $end   = min($i + $match_distance + 1, $t_len);
        for my $j ($start .. $end - 1) {
            next if $t_matches[$j] or $s[$i] ne $t[$j];
            ($s_matches[$i], $t_matches[$j]) = (1, 1);
            $matches++ and last;
        }
    }
    return 0 unless $matches;

    my($k, $transpositions) = (0, 0);
    for my $i (0 .. $#s) {
        next unless $s_matches[$i];
        $k++ until  $t_matches[$k];
        $transpositions++ if $s[$i] ne $t[$k];
        $k++;
    }
    ( $matches/$s_len + $matches/$t_len + (($matches - $transpositions/2) / $matches) ) / 3;
}

printf "%.3f\n", jaro(@$_[0], @$_[1]) for
    ['MARTHA', 'MARHTA'], ['DIXON', 'DICKSONX'], ['JELLYFISH', 'SMELLYFISH'],
    ['I repeat myself', 'I repeat myself'], ['', ''];
