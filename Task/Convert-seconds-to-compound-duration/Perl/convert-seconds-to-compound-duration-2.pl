use strict;
use warnings;
use Math::AnyNum 'polymod';

sub compound_duration {
    my $seconds = shift;
    my @terms;

    my @durations = reverse polymod($seconds, 60, 60, 24, 7);
    my @timespans = <wk d hr min sec>;
    while (my $d = shift @durations, my $t = shift @timespans) {
        push @terms, "$d $t" if $d
    }
    join ', ', @terms
}

for (<7259 86400 6000000 3380521>) {
    printf "%7d sec  =  %s\n", $_, compound_duration($_)
}
