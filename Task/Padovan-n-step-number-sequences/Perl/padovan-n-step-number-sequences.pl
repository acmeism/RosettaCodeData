use strict;
use warnings;
use feature <state say>;
use List::Util 'sum';
use List::Lazy 'lazy_list';

say 'Padovan N-step sequences; first 25 terms:';
for our $N (2..8) {

    my $pad_n = lazy_list {
        state $n  = 2;
        state @pn = (1, 1, 1);
        push @pn, sum @pn[ grep { $_ >= 0 } $n-$N .. $n++ - 1 ];
        $pn[-4]
    };

    print "N = $N |";
    print ' ' . $pad_n->next() for 1..25;
    print "\n"
}
