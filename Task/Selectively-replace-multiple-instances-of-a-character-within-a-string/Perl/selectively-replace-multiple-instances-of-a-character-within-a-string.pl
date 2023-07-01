use strict;
use warnings;
use feature 'say';

sub transmogrify {
    my($str, %sub) = @_;
    for my $l (keys %sub) {
        $str =~ s/$l/$_/ for split '', $sub{$l};
        $str =~ s/_/$l/g;
    }
    $str
}

my $word = 'abracadabra';
say "$word -> " . transmogrify $word, 'a' => 'AB_CD', 'r' => '_F', 'b' => 'E';
