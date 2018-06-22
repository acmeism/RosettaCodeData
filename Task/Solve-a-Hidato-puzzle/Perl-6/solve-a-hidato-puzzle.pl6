my @adjacent = [-1, -1], [-1, 0], [-1, 1],
               [ 0, -1],          [ 0, 1],
               [ 1, -1], [ 1, 0], [ 1, 1];

solveboard q:to/END/;
        __ 33 35 __ __ .. .. ..
        __ __ 24 22 __ .. .. ..
        __ __ __ 21 __ __ .. ..
        __ 26 __ 13 40 11 .. ..
        27 __ __ __  9 __  1 ..
        .. .. __ __ 18 __ __ ..
        .. .. .. .. __  7 __ __
        .. .. .. .. .. ..  5 __
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
