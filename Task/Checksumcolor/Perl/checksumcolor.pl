use strict;
use warnings;
use Term::ANSIColor qw<colored :constants256>;

while (<>) {
    my($cs,$fn) = /(^\S+)\s+(.*)/;
    print colored($_, 'ansi' . hex $_) for $cs =~ /(..)/g;
    print " $fn\n";
}
