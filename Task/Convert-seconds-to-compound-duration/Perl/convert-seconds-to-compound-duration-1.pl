use strict;
use warnings;

sub compound_duration {
    my $sec = shift;
    no warnings 'numeric';

    return join ', ', grep { $_ > 0 }
        int($sec/60/60/24/7)    . " wk",
        int($sec/60/60/24) % 7  . " d",
        int($sec/60/60)    % 24 . " hr",
        int($sec/60)       % 60 . " min",
        int($sec)          % 60 . " sec";
}

for (7259, 86400, 6000000) {
    printf "%7d sec  =  %s\n", $_, compound_duration($_)
}
