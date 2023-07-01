my $GOAL = 100;

package Player;

sub new {
    my ($class,$strategy) = @_;
    my $self = {
        score    => 0,
        rolls    => 0,
        ante     => 0,
        strategy => $strategy || sub { 0 } # as fallback, always roll again
    };
    return bless($self, $class);
}

sub turn {
    my ($P) = @_;
    $P->{rolls} = 0;
    $P->{ante}  = 0;
    my $done    = 0;
    do {
        my $v = 1 + int rand 6;
        $P->{rolls}++;
        if ($v == 1) {
            $P->{ante} = 0;
            $done = 1;
        } else {
            $P->{ante} += $v;
        }
        $done = 1 if $P->{score} + $P->{ante} >= $GOAL or $P->{strategy}();
    } until $done;
    $P->{score} += $P->{ante};
}

package Main;

# default, go-for-broke, always roll again
$players[0] = Player->new;

# try to roll 5 times but no more per turn
$players[1] = Player->new( sub { $players[1]->{rolls} >= 5 } );

# try to accumulate at least 20 points per turn
@players[2] = Player->new( sub { $players[2]->{ante} > 20 } );

# random but 90% chance of rolling again
$players[3] = Player->new( sub { rand() < 0.1 } );

# random but more conservative as approaches goal
$players[4] = Player->new( sub { rand() < ( $GOAL - $players[4]->{score} ) * .6 / $GOAL } );

for (1 .. shift || 100) {
    my $player = -1;
    do {
        $player++;
        @players[$player % @players]->turn;
    } until $players[$player % @players]->{score} >= $GOAL;

    $wins[$player % @players]++;

    printf "%5d", $players[$_]->{score} for 0..$#players; print "\n";
    $players[$_]->{score} = 0 for 0..$#players; # reset scores for next game
}

print ' ----' x @players, "\n";
printf "%5d", $_ for @wins; print "\n";
