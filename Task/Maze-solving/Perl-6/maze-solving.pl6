constant mapping = :OPEN(' '),
		      :N< ╵ >,
		      :E< ╶ >,
		     :NE< └ >,
		      :S< ╷ >,
		     :NS< │ >,
		     :ES< ┌ >,
		    :NES< ├ >,
		      :W< ╴ >,
		     :NW< ┘ >,
		     :EW< ─ >,
		    :NEW< ┴ >,
		     :SW< ┐ >,
		    :NSW< ┤ >,
		    :ESW< ┬ >,
		   :NESW< ┼ >,
		   :TODO< x >,
	          :TRIED< · >;

enum Sym (mapping.map: *.key);
my @ch = mapping.map: *.value;

enum Direction <DeadEnd Up Right Down Left>;

sub gen_maze ( $X,
               $Y,
               $start_x = (^$X).pick * 2 + 1,
               $start_y = (^$Y).pick * 2 + 1 )
{
    my @maze;
    push @maze, $[ flat ES, -N, (ESW, EW) xx $X - 1, SW ];
    push @maze, $[ flat (NS, TODO) xx $X, NS ];
    for 1 ..^ $Y {
	push @maze, $[ flat NES, EW, (NESW, EW) xx $X - 1, NSW ];
	push @maze, $[ flat (NS, TODO) xx $X, NS ];
    }
    push @maze, $[ flat NE, (EW, NEW) xx $X - 1, -NS, NW ];
    @maze[$start_y][$start_x] = OPEN;

    my @stack;
    my $current = [$start_x, $start_y];
    loop {
        if my $dir = pick_direction( $current ) {
            @stack.push: $current;
            $current = move( $dir, $current );
        }
        else {
            last unless @stack;
            $current = @stack.pop;
        }
    }
    return @maze;

    sub pick_direction([$x,$y]) {
	my @neighbors =
	    (Up    if @maze[$y - 2][$x]),
	    (Down  if @maze[$y + 2][$x]),
	    (Left  if @maze[$y][$x - 2]),
	    (Right if @maze[$y][$x + 2]);
	@neighbors.pick or DeadEnd;
    }

    sub move ($dir, @cur) {
	my ($x,$y) = @cur;
	given $dir {
	    when Up    { @maze[--$y][$x] = OPEN; @maze[$y][$x-1] -= E; @maze[$y--][$x+1] -= W; }
	    when Down  { @maze[++$y][$x] = OPEN; @maze[$y][$x-1] -= E; @maze[$y++][$x+1] -= W; }
	    when Left  { @maze[$y][--$x] = OPEN; @maze[$y-1][$x] -= S; @maze[$y+1][$x--] -= N; }
	    when Right { @maze[$y][++$x] = OPEN; @maze[$y-1][$x] -= S; @maze[$y+1][$x++] -= N; }
	}
	@maze[$y][$x] = 0;
	[$x,$y];
    }
}

sub display (@maze) {
    for @maze -> @y {
	for @y.rotor(2) -> ($w, $c) {
	    print @ch[abs $w];
	    if $c >= 0 { print @ch[$c] x 3 }
	    else { print ' ', @ch[abs $c], ' ' }
	}
	say @ch[@y[*-1]];
    }
}

sub solve (@maze is copy, @from = [1, 1], @to = [@maze[0] - 2, @maze - 2]) {
    my ($x, $y) = @from;
    my ($xto, $yto) = @to;
    my @stack;

    sub drop-crumb($x,$y,$c) { @maze[$y][$x] = -$c }
    drop-crumb($x,$y,N);

    loop {
	my $dir = pick_direction([$x,$y]);
	if $dir {
	    ($x, $y) = move($dir, [$x,$y]);
	    return @maze if $x == $xto and $y == $yto;
	}
	else {
	    @maze[$y][$x] = -TRIED;
	    ($x,$y) = @stack.pop;
	    @maze[$y][$x] = -TRIED;
	    ($x,$y) = @stack.pop;
	}
    }

    sub pick_direction([$x,$y]) {
	my @neighbors =
	    (Up    unless @maze[$y - 1][$x]),
	    (Down  unless @maze[$y + 1][$x]),
	    (Left  unless @maze[$y][$x - 1]),
	    (Right unless @maze[$y][$x + 1]);
	@neighbors.pick or DeadEnd;
    }

    sub move ($dir, @cur) {
	my ($x,$y) = @cur;
	given $dir {
	    when Up    { for ^2 { push @stack, $[$x,$y--]; drop-crumb $x,$y,S; } }
	    when Down  { for ^2 { push @stack, $[$x,$y++]; drop-crumb $x,$y,N; } }
	    when Left  { for ^2 { push @stack, $[$x--,$y]; drop-crumb $x,$y,E; } }
	    when Right { for ^2 { push @stack, $[$x++,$y]; drop-crumb $x,$y,W; } }
	}
	$x,$y;
    }
}

display solve gen_maze( 29, 19 );
