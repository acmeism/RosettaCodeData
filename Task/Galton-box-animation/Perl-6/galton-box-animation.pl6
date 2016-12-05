my $row-count = 6;

constant $peg = "*";
constant @coin-icons = "\c[UPPER HALF BLOCK]", "\c[LOWER HALF BLOCK]";

sub display-board(@positions, @stats is copy, $halfstep) {
    my $coin = @coin-icons[$halfstep.Int];

    state @board-tmpl = {
        # precompute a board
        my @tmpl;
        sub out(*@stuff) {
            @tmpl.push: $[@stuff.join>>.ords.flat];
        }
        # three lines of space above
        for 1..3 {
            out "  ", " " x (2 * $row-count);
        }
        # $row-count lines of pegs
        for flat ($row-count...1) Z (1...$row-count) -> $spaces, $pegs {
            out "  ", " " x $spaces, ($peg xx $pegs).join(" "), " " x $spaces;
        }
        # four lines of space below
        for 1..4 {
            out "  ", " " x (2 * $row-count);
        }
        @tmpl
    }();

    my $midpos = $row-count + 2;

    my @output;
    {
        # collect all the output and output it all at once at the end
        sub say(Str $foo) {
            @output.push: $foo, "\n";
        }
        sub print(Str $foo) {
            @output.push: $foo;
        }

        # make some space above the picture
        say "" for ^10;

        my @output-lines = map { [ @$_ ] }, @board-tmpl;
        # place the coins
        for @positions.kv -> $line, $pos {
            next unless $pos.defined;
            @output-lines[$line][$pos + $midpos] = $coin.ord;
        }
        # output the board with its coins
        for @output-lines -> @line {
            say @line.chrs;
        }

        # show the statistics
        my $padding = 0;
        while any(@stats) > 0 {
            $padding++;
            print "  ";
            @stats = do for @stats -> $stat {
                given $stat {
                    when 1 {
                        print "\c[UPPER HALF BLOCK]";
                        $stat - 1;
                    }
                    when * <= 0 {
                        print " ";
                        0
                    }
                    default {
                        print "\c[FULL BLOCK]";
                        $stat - 2;
                    }
                }
            }
            say "";
        }
        say "" for $padding...^10;
    }
    say @output.join("");
}

sub simulate($coins is copy) {
    my $alive = True;

    sub hits-peg($x, $y) {
        if 3 <= $y < 3 + $row-count and -($y - 2) <= $x <= $y - 2 {
            return not ($x - $y) %% 2;
        }
        return False;
    }

    my @coins = Int xx (3 + $row-count + 4);
    my @stats = 0 xx ($row-count * 2);
    # this line will dispense coins until turned off.
    @coins[0] = 0;
    while $alive {
        $alive = False;
        # if a coin falls through the bottom, count it
        given @coins[*-1] {
            when *.defined {
                @stats[$_ + $row-count]++;
            }
        }

        # move every coin down one row
        for ( 3 + $row-count + 3 )...1 -> $line {
            my $coinpos = @coins[$line - 1];

            @coins[$line] = do if not $coinpos.defined {
                Nil
            } elsif hits-peg($coinpos, $line) {
                # when a coin from above hits a peg, it will bounce to either side.
                $alive = True;
                ($coinpos - 1, $coinpos + 1).pick;
            } else {
                # if there was a coin above, it will fall to this position.
                $alive = True;
                $coinpos;
            }
        }
        # let the coin dispenser blink and turn it off if we run out of coins
        if @coins[0].defined {
            @coins[0] = Nil
        } elsif --$coins > 0 {
            @coins[0] = 0
        }

        # smooth out the two halfsteps of the animation
        my $start-time;
        ENTER { $start-time = now }
        my $wait-time = now - $start-time;

        sleep 0.1 - $wait-time if $wait-time < 0.1;
        for @coin-icons.keys {
            sleep $wait-time max 0.1;
            display-board(@coins, @stats, $_);
        }
    }
}

sub MAIN($coins = 20, $peg-lines = 6) {
    $row-count = $peg-lines;
    simulate($coins);
}
