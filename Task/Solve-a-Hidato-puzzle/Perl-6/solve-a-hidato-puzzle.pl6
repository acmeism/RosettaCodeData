my @grid;
my @known;

sub show_board() {
    my $width = $*max.chars;
    for @grid -> $r {
	say do for @$r {
	    when Rat { ' ' x $width }
	    when 0   { '_' x $width }
	    default  { .fmt("%{$width}d") }
	}
    }
}

sub neighbors($y,$x --> List) {
    gather for [-1, -1], [-1, 0], [-1, 1],
	       [ 0, -1],          [ 0, 1],
	       [ 1, -1], [ 1, 0], [ 1, 1]
    {
	my $y1 = $y + .[0];
	my $x1 = $x + .[1];
	take [$y1,$x1] if defined @grid[$y1][$x1];
    }
}

sub try_fill($v, $coord [$y,$x] --> Bool) {
    return True if $v > $*max;

    my $old = @grid[$y][$x];

    return False if $old and $old != $v;
    return False if @known[$v] and @known[$v] !eqv $coord;

    @grid[$y][$x] = $v;
    print "\e[0H";
    show_board();

    for neighbors($y, $x) {
	return True if try_fill $v + 1, $_;
    }

    @grid[$y][$x] = $old;
    return False;
}

sub hidato($board) {
    my $*max = [max] +«$board.comb(/\d+/);

    @grid = $board.lines.map: -> $line {
	[ $line.words.map: { /^_/ ?? 0 !! /^\./ ?? Rat !! $_ } ]
    }
    for ^@grid -> $y {
	for ^@grid[$y] -> $x {
	    if @grid[$y][$x] -> $v {
		@known[$v] = [$y,$x];
	    }
	}
    }
    print "\e[0H\e[0J";
    try_fill 1, @known[1];
}

hidato q:to/END/;
 	__ 33 35 __ __ .. .. ..
	__ __ 24 22 __ .. .. ..
	__ __ __ 21 __ __ .. ..
	__ 26 __ 13 40 11 .. ..
	27 __ __ __  9 __  1 ..
	.. .. __ __ 18 __ __ ..
	.. .. .. .. __  7 __ __
	.. .. .. .. .. ..  5 __
	END
