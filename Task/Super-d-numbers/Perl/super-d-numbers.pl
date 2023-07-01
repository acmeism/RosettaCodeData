use strict;
use warnings;
use bigint;
use feature 'say';

sub super {
    my $d = shift;
    my $run = $d x $d;
    my @super;
    my $i = 0;
    my $n = 0;
    while ( $i < 10 ) {
        if (index($n ** $d * $d, $run) > -1) {
            push @super, $n;
            ++$i;
        }
        ++$n;
    }
    @super;
}

say "\nFirst 10 super-$_ numbers:\n", join ' ', super($_) for 2..6;
