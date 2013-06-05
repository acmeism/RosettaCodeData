constant size = 100;
constant particlenum = 1_000;


constant mid = size div 2;

my $spawnradius = 5;
my @map;

sub set($x, $y) {
    @map[$x][$y] = True;
}

sub get($x, $y) {
    return @map[$x][$y] || False;
}

set(mid, mid);
my @blocks = " ","\c[UPPER HALF BLOCK]", "\c[LOWER HALF BLOCK]","\c[FULL BLOCK]";

sub infix:<█>($a, $b) {
    @blocks[$a + 2 * $b]
}

sub display {
    my $start = 0;
    my $end = size;
    say (for $start, $start + 2 ... $end -> $y {
        (for $start..$end -> $x {
            if abs(($x&$y) - mid) < $spawnradius {
                get($x, $y) █ get($x, $y+1);
            } else {
                " "
            }
        }).join
    }).join("\n")
}

for ^particlenum -> $progress {
    my Int $x;
    my Int $y;
    my &reset = {
        repeat {
            ($x, $y) = (mid - $spawnradius..mid + $spawnradius).pick, (mid - $spawnradius, mid + $spawnradius).pick;
            ($x, $y) = ($y, $x) if (True, False).pick();
        } while get($x,$y);
    }
    reset;

    while not get($x-1|$x|$x+1, $y-1|$y|$y+1) {
        $x = ($x-1, $x, $x+1).pick;
        $y = ($y-1, $y, $y+1).pick;
        if (False xx 3, True).pick {
            $x = $x >= mid ?? $x - 1 !! $x + 1;
            $y = $y >= mid ?? $y - 1 !! $y + 1;
        }
        if abs(($x | $y) - mid) > $spawnradius {
            reset;
        }
    }
    set($x,$y);
    display if $progress %% 50;
    if $spawnradius < mid && abs(($x|$y) - mid) > $spawnradius - 5 {
        $spawnradius = $spawnradius + 1;
    }
}

say "";
display;
say "";
say "time elapsed: ", (now - BEGIN { now }).Num.fmt("%.2f"), " seconds";
say "";
