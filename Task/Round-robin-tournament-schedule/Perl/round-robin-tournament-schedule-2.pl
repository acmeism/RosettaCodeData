use strict;
use warnings;
use feature 'say';
use List::AllUtils <pairwise all>;

sub round_robin {
    my($n) = @_;
    my($round,@pairings);
    my @players = (1,0)[$n%2] .. $n;
    my $half    = +@players / 2;

    while () {
        my @a =         @players[    0 ..   $half-1];
        my @b = reverse @players[$half .. $#players];
        push @pairings, sprintf "Round %2d: %s\n", ++$round, join ' ', pairwise { sprintf "%3d vs %2d", $a, $b } @a, @b;
        push @players, splice @players, 1, @players-2;
        last if all { $players[$_-1] < $players[$_] } 1..$#players;
    }
    @pairings
}

say join '', round_robin 12;
say '';
say join '', map { s/0 vs /Bye: /r } round_robin 7;
