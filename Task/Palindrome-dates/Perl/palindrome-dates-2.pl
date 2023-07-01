use strict;
use warnings;
use feature 'say';
use ntheory qw/forsetproduct/;

my $start = '2020-02-02' =~ s/-//gr;
my($y) = substr($start,0,4);

my(@dates,$cnt);
forsetproduct { push @dates, "@_" } [$y..$y+999],['01'..'12'],['01'..'31'];
for (@dates) {
    (my $date = $_) =~ s/ //g;
    next unless $date > $start and $date eq reverse $date;
    say s/ /-/gr;
    last if 15 == ++$cnt;
}
