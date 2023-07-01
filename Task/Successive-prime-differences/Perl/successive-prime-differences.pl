use strict;
use warnings;
use List::EachCons;
use Array::Compare;
use ntheory 'primes';

my $limit = 1E6;
my @primes = (2, @{ primes($limit) });
my @intervals = map { $primes[$_] - $primes[$_-1] } 1..$#primes;

print "Groups of successive primes <= $limit\n";

my $c = Array::Compare->new;
for my $diffs ([2], [1], [2,2], [2,4], [4,2], [6,4,2]) {
    my $n = -1;
    my @offsets = grep {$_} each_cons @$diffs, @intervals, sub { $n++; $n if $c->compare(\@_, \@$diffs) };
    printf "%10s has %5d sets: %15s … %s\n",
       '(' . join(' ',@$diffs) . ')',
        scalar @offsets,
        join(' ', @primes[$offsets[ 0]..($offsets[ 0]+@$diffs)]),
        join(' ', @primes[$offsets[-1]..($offsets[-1]+@$diffs)]);
}
