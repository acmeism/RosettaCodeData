use strict;
use warnings;
use feature 'say';

sub cocktail_sort {
    my @a = @_;
    my ($min, $max) = (0, $#a-1);
    while (1) {
        my $swapped_forward = 0;
        for my $i ($min .. $max) {
            if ($a[$i] gt $a[$i+1]) {
                @a[$i, $i+1] = @a[$i+1, $i];
                $swapped_forward = 1
            }
        }
        last if not $swapped_forward;
        $max -= 1;

        my $swapped_backward = 0;
        for my $i (reverse $min .. $max) {
            if ($a[$i] gt $a[$i+1]) {
                @a[$i, $i+1] = @a[$i+1, $i];
                $swapped_backward = 1;
            }
        }
        last if not $swapped_backward;
        $min += 1;
    }
    @a
}

say join ' ', cocktail_sort( <t h e q u i c k b r o w n f o x j u m p s o v e r t h e l a z y d o g> );
