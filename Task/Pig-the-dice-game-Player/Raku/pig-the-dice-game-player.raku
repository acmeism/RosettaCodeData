my $games = @*ARGS ?? (shift @*ARGS) !! 100;

constant DIE = 1 .. 6;
constant GOAL = 100;

class player {
    has $.score    is rw = 0;
    has $.ante     is rw;
    has $.rolls    is rw;
    has &.strategy is rw = sub { False }; # default, always roll again

    method turn {
        my $done_turn = False;
        $.rolls = 0;
        $.ante  = 0;
        repeat {
            given DIE.roll {
                $.rolls++;
                when 1 {
                    $.ante = 0;
                    $done_turn = True;
                }
                when 2..* {
                    $.ante += $_;
                }
            }
            $done_turn = True if $.score + $.ante >= GOAL or (&.strategy)();
        } until $done_turn;
        $.score += $.ante;
    }
}

my @players;

# default, go-for-broke, always roll again
@players[0] = player.new;

# try to roll 5 times but no more per turn
@players[1] = player.new( strategy => sub { @players[1].rolls >= 5 } );

# try to accumulate at least 20 points per turn
@players[2] = player.new( strategy => sub { @players[2].ante > 20 } );

# random but 90% chance of rolling again
@players[3] = player.new( strategy => sub { 1.rand < .1 } );

# random but more conservative as approaches goal
@players[4] = player.new( strategy => sub { 1.rand < ( GOAL - @players[4].score ) * .6 / GOAL } );

my @wins = 0 xx @players;

for ^ $games {
    my $player = -1;
    repeat {
        $player++;
        @players[$player % @players].turn;
    } until @players[$player % @players].score >= GOAL;

    @wins[$player % @players]++;

    say join "\t", @players>>.score;
    @players[$_].score = 0 for ^@players; # reset scores for next game
}

say "\nSCORES: for $games games";
say join "\t", @wins;
