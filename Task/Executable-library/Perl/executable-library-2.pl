use Hailstone;
use strict;
use warnings;

my %seqs;
for (1 .. 100_000) {
    $seqs{Hailstone::len($_)}++;
}

my ($most_frequent) = sort {$seqs{$b} <=> $seqs{$a}} keys %seqs;
print "Most frequent length: $most_frequent ($seqs{$most_frequent} occurrences)\n";
