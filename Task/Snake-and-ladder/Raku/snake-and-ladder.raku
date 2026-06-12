        # board layout
my %snl =  4, 14,  9, 31, 17,  7, 20, 38, 28, 84, 40, 59, 51, 67, 54, 34,
          62, 19, 63, 81, 64, 60, 71, 91, 87, 24, 93, 73, 95, 75, 99, 78;

my @players = 1, 1, 1; # three players, starting on square 1
my $human = 1;         # player 1 is human. set to 0 for all computer players

loop {
    for ^@players -> $player {
        turn(@players[$player], $player + 1);
    }
    say '';
}

sub turn ($square is rw, $player) {
    if $player == $human {
        prompt "You are on square $square. Hit enter to roll the die.";
    }
    my $roll = (1..6).roll;
    my $turn = $square + $roll;
    printf "Player $player on square %2d rolls a $roll", $square;
    if $turn > 100 {
        say " but cannot move. Next players turn.";
        return $square;
    }
    if %snl{$turn} {
        $square = %snl{$turn};
        if $turn > $square {
            say ". Oops! Landed on a snake. Slither down to $square."
        } else {
            say ". Yay! Landed on a ladder. Climb up to $square."
        }
    } else {
        $square = $turn;
        say " and moves to square $square";
    }
    say "Player $player wins!" and exit if $square == 100;
    return $square;
}
