my @adjacent =           [-1, 0],
               [ 0, -1],          [ 0, 1],
                         [ 1, 0];
put "\n" xx 60;

solveboard q:to/END/;
    __ __ __ __ __ __ __ __ __
    __ __ 46 45 __ 55 74 __ __
    __ 38 __ __ 43 __ __ 78 __
    __ 35 __ __ __ __ __ 71 __
    __ __ 33 __ __ __ 59 __ __
    __ 17 __ __ __ __ __ 67 __
    __ 18 __ __ 11 __ __ 64 __
    __ __ 24 21 __  1  2 __ __
    __ __ __ __ __ __ __ __ __
    END

# And
put "\n" xx 60;

solveboard q:to/END/;
    0  0  0  0  0  0  0  0  0
    0 11 12 15 18 21 62 61  0
    0  6  0  0  0  0  0 60  0
    0 33  0  0  0  0  0 57  0
    0 32  0  0  0  0  0 56  0
    0 37  0  1  0  0  0 73  0
    0 38  0  0  0  0  0 72  0
    0 43 44 47 48 51 76 77  0
    0  0  0  0  0  0  0  0  0
    END


sub solveboard($board) {
    my $max = +$board.comb(/\w+/);
    my $width = $max.chars;

    my @grid;
    my @known;
    my @neigh;
    my @degree;

    @grid = $board.lines.map: -> $line {
        [ $line.words.map: { /^_/ ?? 0 !! /^\./ ?? Rat !! $_ } ]
    }

    sub neighbors($y,$x --> List) {
        eager gather for @adjacent {
            my $y1 = $y + .[0];
            my $x1 = $x + .[1];
            take [$y1,$x1] if defined @grid[$y1][$x1];
        }
    }

    for ^@grid -> $y {
        for ^@grid[$y] -> $x {
            if @grid[$y][$x] -> $v {
                @known[$v] = [$y,$x];
            }
            if @grid[$y][$x].defined {
                @neigh[$y][$x] = neighbors($y,$x);
                @degree[$y][$x] = +@neigh[$y][$x];
            }
        }
    }
    print "\e[0H\e[0J";

    my $tries = 0;

    try_fill 1, @known[1];

    sub try_fill($v, $coord [$y,$x] --> Bool) {
        return True if $v > $max;
        $tries++;

        my $old = @grid[$y][$x];

        return False if +$old and $old != $v;
        return False if @known[$v] and @known[$v] !eqv $coord;

        @grid[$y][$x] = $v;               # conjecture grid value

        print "\e[0H";                    # show conjectured board
        for @grid -> $r {
            say do for @$r {
                when Rat { ' ' x $width }
                when 0   { '_' x $width }
                default  { .fmt("%{$width}d") }
            }
        }


        my @neighbors = @neigh[$y][$x][];

        my @degrees;
        for @neighbors -> \n [$yy,$xx] {
            my $d = --@degree[$yy][$xx];  # conjecture new degrees
            push @degrees[$d], n;         # and categorize by degree
        }

        for @degrees.grep(*.defined) -> @ties {
            for @ties.reverse {           # reverse works better for this hidato anyway
                return True if try_fill $v + 1, $_;
            }
        }

        for @neighbors -> [$yy,$xx] {
            ++@degree[$yy][$xx];          # undo degree conjectures
        }

        @grid[$y][$x] = $old;             # undo grid value conjecture
        return False;
    }

    say "$tries tries";
}
