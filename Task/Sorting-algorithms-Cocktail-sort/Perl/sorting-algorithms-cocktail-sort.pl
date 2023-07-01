use strict;
use warnings;
use feature 'say';

sub cocktail_sort {
    my @a = @_;
    while (1) {
        my $swapped_forward = 0;
        for my $i (0..$#a-1) {
            if ($a[$i] gt $a[$i+1]) {
                @a[$i, $i+1] = @a[$i+1, $i];
                $swapped_forward = 1;
            }
        }
        last if not $swapped_forward;

        my $swapped_backward = 0;
        for my $i (reverse 0..$#a-1) {
            if ($a[$i] gt $a[$i+1]) {
                @a[$i, $i+1] = @a[$i+1, $i];
                $swapped_backward = 1;
            }
        }
        last if not $swapped_backward;
    }
    @a
}

say join ' ', cocktail_sort( <t h e q u i c k b r o w n f o x j u m p s o v e r t h e l a z y d o g> );
