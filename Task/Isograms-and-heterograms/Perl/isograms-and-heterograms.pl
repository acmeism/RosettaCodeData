use strict;
use warnings;
use feature 'say';
use Path::Tiny;
use List::Util 'uniq';

my @words = map { lc } path('unixdict.txt')->slurp =~ /^[A-z]{2,}$/gm;

my(@heterogram, %isogram);
for my $w (@words) {
    my %l;
    $l{$_}++ for split '', $w;
    next unless 1 == scalar (my @x = uniq values %l);
    if ($x[0] == 1) { push @heterogram,        $w if length $w > 10 }
    else            { push @{$isogram{$x[0]}}, $w                   }
}

for my $n (reverse sort keys %isogram) {
    my @i = sort { length $b <=> length $a } @{$isogram{$n}};
    say scalar @i . " $n-isograms:\n" . join("\n", @i) . "\n";
}

say scalar(@heterogram) . " heterograms with more than 10 characters:\n" . join "\n", sort { length $b <=> length $a } @heterogram;
