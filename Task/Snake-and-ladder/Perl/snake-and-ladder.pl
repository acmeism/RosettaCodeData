# board layout
my %snl =( 4, 14,  9, 31, 17,  7, 20, 38, 28, 84, 40, 59, 51, 67, 54, 34,
          62, 19, 63, 81, 64, 60, 71, 91, 87, 24, 93, 73, 95, 75, 99, 78);

@players = (1, 1, 1, 1); # 4 players, starting on square 1 (last player is human)

while () {
    for $player (0..$#players) {
       $turn_count++;
       turn(\$players[$player], $player + 1, $turn_count);
    }
}

sub turn {
    my($square, $player) = @_;
    if ($player == @players) { print "You are on square $$square. Hit enter to roll the die:"; <> }
    my $roll = 1 + int rand 6;
    my $turn = $$square + $roll;
    print "Player $player on square %2d rolls a $roll", $$square;
    if ($turn > 100) {
       print " but cannot move. Next players turn.\n";
       return
    }
    if ($snl{$turn}) {
        $$square = $snl{$turn};
        if ($turn > $$square) {
           print ". Oops! Landed on a snake. Slither down to $$square.\n"
        } else {
           print ". Yay! Landed on a ladder. Climb up to $$square.\n"
        }
    } else {
        $$square = $turn;
        print " and moves to square $$square\n";
    }
    if ($$square == 100) {print "Player $player wins after $turn_count turns.\n"; exit }
    return
}
