use strict;
use warnings;
use bigint;

my $dcnt = 1;
my @ok = my @magic = 0..9; shift @ok;
while () {
    $dcnt++;
    my @candidates = ();
    for my $d (0..9) { push @candidates, map { 10*$_ + $d } @ok }
    (@ok = grep { 0 == $_ % $dcnt } @candidates) ? push(@magic, @ok) : last;
}

printf "There are %d magic numbers in total.\nThe largest is %s.\n\n", scalar(@magic), $magic[-1];

my %M; $M{length $_}++ for @magic;
for my $k (sort { $a <=> $b } keys %M) {
    printf " %6d with %3d digit%s\n",  $M{$k}, $k, $k>1?'s':'';
}

for my $i (1,0) {
    my $digits = join '', $i..9;
    printf "\nMagic number(s) pan-digital in $i through 9 with no repeats: %s\n",
        grep { length $_ == 10-$i and $digits eq join '', sort split '', $_ } @magic;
}
