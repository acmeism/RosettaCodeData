use strict;
use warnings;
use feature 'say';
use List::Util 'shuffle';

sub simulation {
    my($population,$trials,$strategy) = @_;
    my $optimal   = $strategy =~ /^o/i ? 1 : 0;
    my @prisoners = 0..$population-1;
    my $half      = int $population / 2;
    my $pardoned  = 0;

    for (1..$trials) {
        my @drawers = shuffle @prisoners;
        my $total = 0;
        for my $prisoner (@prisoners) {
            my $found = 0;
            if ($optimal) {
                my $card = $drawers[$prisoner];
                if ($card == $prisoner) {
                    $found = 1;
                } else {
                    for (1..$half-1) {
                        $card = $drawers[$card];
                        ($found = 1, last) if $card == $prisoner
                    }
                }
            } else {
                for my $card ( (shuffle @drawers)[0..$half]) {
                    ($found = 1, last) if $card == $prisoner
                }
            }
            last unless $found;
            $total++;
        }
        $pardoned++ if $total == $population;
    }
    $pardoned / $trials * 100
}

my $population = 100;
my $trials     = 10000;
say " Simulation count: $trials\n" .
(sprintf " Random strategy pardons: %6.3f%% of simulations\n", simulation $population, $trials, 'random' ) .
(sprintf "Optimal strategy pardons: %6.3f%% of simulations\n", simulation $population, $trials, 'optimal');

$population = 10;
$trials     = 100000;
say " Simulation count: $trials\n" .
(sprintf " Random strategy pardons: %6.3f%% of simulations\n", simulation $population, $trials, 'random' ) .
(sprintf "Optimal strategy pardons: %6.3f%% of simulations\n", simulation $population, $trials, 'optimal');
