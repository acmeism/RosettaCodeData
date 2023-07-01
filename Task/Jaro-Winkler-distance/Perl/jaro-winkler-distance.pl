use strict;
use warnings;
use List::Util qw(min max head);

sub jaro_winkler {
    my($s, $t) = @_;
    my(@s_matches, @t_matches, $matches);

    return 0 if $s eq $t;

    my $s_len = length $s; my @s = split //, $s;
    my $t_len = length $t; my @t = split //, $t;

    my $match_distance = int (max($s_len,$t_len)/2) - 1;

    for my $i (0 .. $#s) {
        my $start = max(0, $i - $match_distance);
        my $end   = min($i + $match_distance, $t_len - 1);
        for my $j ($start .. $end) {
            next if $t_matches[$j] or $s[$i] ne $t[$j];
            ($s_matches[$i], $t_matches[$j]) = (1, 1);
            $matches++ and last;
        }
    }
    return 1 unless $matches;

    my($k, $transpositions) = (0, 0);

    for my $i (0 .. $#s) {
        next unless $s_matches[$i];
        $k++ until  $t_matches[$k];
        $transpositions++ if $s[$i] ne $t[$k];
        $k++;
    }

    my $prefix = 0;
    $s[$_] eq $t[$_] and ++$prefix for 0 .. -1 + min 5, $s_len, $t_len;

    my $jaro = ($matches / $s_len + $matches / $t_len +
        (($matches - $transpositions / 2) / $matches)) / 3;

    1 - ($jaro + $prefix * .1 * ( 1 - $jaro) )
}

my @words = split /\n/, `cat ./unixdict.txt`;

for my $word (<accomodate definately goverment occured publically recieve seperate untill wich>) {
    my %J;
    $J{$_} = jaro_winkler($word, $_) for @words;
    print "\nClosest 5 dictionary words with a Jaro-Winkler distance < .15 from '$word':\n";
    printf "%15s : %0.4f\n", $_, $J{$_}
         for head 5, sort { $J{$a} <=> $J{$b} or $a cmp $b } grep { $J{$_} < 0.15 } keys %J;
}
