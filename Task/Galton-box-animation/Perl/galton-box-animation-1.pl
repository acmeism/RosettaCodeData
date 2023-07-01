use strict;
use warnings;

use List::Util 'any';
use Time::HiRes qw(sleep);
use List::AllUtils <pairwise pairs>;

use utf8;
binmode STDOUT, ':utf8';

my $coins      = shift || 100;
my $peg_lines  = shift || 13;
my $row_count  = $peg_lines;
my $peg        = '^';
my @coin_icons = ("\N{UPPER HALF BLOCK}", "\N{LOWER HALF BLOCK}");

my @coins = (undef) x (3 + $row_count + 4);
my @stats = (0) x ($row_count * 2);
$coins[0] = 0; # initialize with first coin

while (1) {
    my $active = 0;
    # if a coin falls through the bottom, count it
    $stats[$coins[-1] + $row_count]++ if defined $coins[-1];

    # move every coin down one row
    for my $line (reverse 1..(3+$row_count+3) ) {
        my $coinpos = $coins[$line - 1];

        #$coins[$line] = do if (! defined $coinpos) x
        if (! defined $coinpos) {
            $coins[$line] = undef
        } elsif (hits_peg($coinpos, $line)) {
            # when a coin from above hits a peg, it will bounce to either side.
            $active = 1;
            $coinpos += rand() < .5 ? -1 : 1;
            $coins[$line] = $coinpos
        } else {
            # if there was a coin above, it will fall to this position.
            $active = 1;
            $coins[$line] = $coinpos;
        }
    }
    # let the coin dispenser blink and turn it off if we run out of coins
    if (defined $coins[0]) {
        $coins[0] = undef;
    } elsif (--$coins > 0) {
        $coins[0] = 0
    }

    for (<0 1>) {
        display_board(\@coins, \@stats, $_);
        sleep .1;
    }
    exit unless $active;
}

sub display_board {
    my($p_ref, $s_ref, $halfstep) = @_;
    my @positions = @$p_ref;
    my @stats     = @$s_ref;
    my $coin      = $coin_icons[$halfstep];

    my @board = do {
        my @tmpl;

        sub out {
            my(@stuff) = split '', shift;
            my @line;
            push @line, ord($_) for @stuff;
            [@line];
        }

        push @tmpl, out("  " . " "x(2 * $row_count)) for 1..3;
        my @a = reverse 1..$row_count;
        my @b = 1..$row_count;
        my @pairs = pairwise { ($a, $b) } @a, @b;
        for ( pairs @pairs ) {
            my ( $spaces, $pegs ) = @$_;
            push @tmpl, out("  " . " "x$spaces . join(' ',($peg) x $pegs) . " "x$spaces);
        }
        push @tmpl, out("  " . " "x(2 * $row_count)) for 1..4;
        @tmpl;
    };

    my $midpos = $row_count + 2;

    our @output;
    {
        # collect all the output and output it all at once at the end
        sub printnl { my($foo) = @_; push @output, $foo . "\n" }
        sub printl  { my($foo) = @_; push @output, $foo        }

        # make some space above the picture
        printnl("") for 0..9;

        # place the coins
        for my $line (0..$#positions) {
            my $pos = $positions[$line];
            next unless defined $pos;
            $board[$line][$pos + $midpos] = ord($coin);
        }
        # output the board with its coins
        for my $line (@board) {
            printnl join '', map { chr($_) } @$line;
        }

        # show the statistics
        my $padding = 0;
        while (any {$_> 0} @stats) {
            $padding++;
            printl "  ";
            for my $i (0..$#stats) {
                if ($stats[$i] == 1) {
                        printl "\N{UPPER HALF BLOCK}";
                        $stats[$i]--;
                } elsif ($stats[$i] <= 0) {
                        printl " ";
                        $stats[$i] = 0
                } else {
                        printl "\N{FULL BLOCK}";
                        $stats[$i]--; $stats[$i]--;
                }
            }
            printnl("");
        }
        printnl("") for $padding..(10-1);
    }

    print join('', @output) . "\n";
}

sub hits_peg {
    my($x, $y) = @_;
    3 <= $y && $y < (3 + $row_count) and -($y - 2) <= $x && $x <= $y - 2
        ? not 0 == ($x - $y) % 2
        : 0
}
