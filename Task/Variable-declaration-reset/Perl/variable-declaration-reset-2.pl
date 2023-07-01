use strict;
use warnings;
use feature 'state';

my @s = <1 2 2 3 4 4 5>;
for (my $i = 0; $i < 7; $i++) {
    my $curr = $s[$i];
    state $prev;
    if ($i > 1 and $curr == $prev) { print "$i\n" }
    $prev = $curr;
}
