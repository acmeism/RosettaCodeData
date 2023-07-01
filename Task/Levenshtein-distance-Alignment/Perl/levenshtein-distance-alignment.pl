use strict;
use warnings;

use List::Util qw(min);

sub levenshtein_distance_alignment {
    my @s = ('^', split //, shift);
    my @t = ('^', split //, shift);

    my @A;
    @{$A[$_][0]}{qw(d s t)} = ($_, join('', @s[1 .. $_]), ('~' x $_)) for 0 .. $#s;
    @{$A[0][$_]}{qw(d s t)} = ($_, ('-' x $_), join '', @t[1 .. $_])  for 0 .. $#t;
    for my $i (1 .. $#s) {
        for my $j (1 .. $#t) {
	    if ($s[$i] ne $t[$j]) {
		$A[$i][$j]{d} = 1 + (
		    my $min = min $A[$i-1][$j]{d}, $A[$i][$j-1]{d}, $A[$i-1][$j-1]{d}
		);
		@{$A[$i][$j]}{qw(s t)} =
		$A[$i-1][$j]{d} == $min ? ($A[$i-1][$j]{s}.$s[$i], $A[$i-1][$j]{t}.'-') :
		$A[$i][$j-1]{d} == $min ? ($A[$i][$j-1]{s}.'-', $A[$i][$j-1]{t}.$t[$j]) :
		($A[$i-1][$j-1]{s}.$s[$i], $A[$i-1][$j-1]{t}.$t[$j]);
	    }
            else {
		@{$A[$i][$j]}{qw(d s t)} = (
		    $A[$i-1][$j-1]{d},
		    $A[$i-1][$j-1]{s}.$s[$i],
		    $A[$i-1][$j-1]{t}.$t[$j]
		);
            }
        }
    }
    return @{$A[-1][-1]}{'s', 't'};
}

print  join "\n", levenshtein_distance_alignment "rosettacode", "raisethysword";
