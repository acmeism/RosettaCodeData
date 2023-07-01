use strict 'vars';
use warnings;
use feature 'say';
use bigint;

my @b = 1;
my @Aitkens = [1];

push @Aitkens, do {
    my @c = $b[-1];
    push @c, $b[$_] + $c[$_] for 0..$#b;
    @b = @c;
    [@c]
} until (@Aitkens == 50);

my @Bell_numbers = map { @$_[0] } @Aitkens;

say 'First fifteen and fiftieth Bell numbers:';
printf "%2d: %s\n", 1+$_, $Bell_numbers[$_] for 0..14, 49;

say "\nFirst ten rows of Aitken's array:";
printf '%-7d'x@{$Aitkens[$_]}."\n", @{$Aitkens[$_]} for 0..9;
