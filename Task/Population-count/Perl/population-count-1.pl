use strict;
use warnings;
use feature 'say';

sub evil {
    my $i = 0;
    sub { $i++ while population_count($i) % 2; $i++ }
}

sub odious {
    my $i = 0;
    sub { $i++ until population_count($i) % 2; $i++ }
}

sub population_count {
    my $n = shift;
    my $c;
    for ($c = 0; $n; $n >>= 1) { $c += $n & 1 }
    $c
}

say join ' ', map { population_count 3**$_ } 0 .. 30 - 1;

my (@evil, @odious);
my ($evil, $odious) = (evil, odious);
push( @evil, $evil->() ), push @odious, $odious->() for 1 .. 30;

say "Evil   @evil";
say "Odious @odious";
