my @bond;
my $grid = 10;
my $geom = $grid - 1;
my $water = '▒';

enum Direction <DeadEnd Up Right Down Left>;

say 'Sample percolation at .6';
percolate .6;
.join.say for @bond;
say "\n";

my $tests = 100;
say "Doing $tests trials at each porosity:";
for .1, .2 ... 1 -> $p {
    printf "p = %0.1f: %0.2f\n", $p, (sum percolate($p) xx $tests) / $tests
}

sub percolate ( $prob ) {
    generate $prob;
    my @stack;
    my $current = [1;0];
    $current.&fill;

    loop {
        if my $dir = direction( $current ) {
            @stack.push: $current;
            $current = move $dir, $current
        }
        else {
            return False unless @stack;
            $current = @stack.pop
        }
        return True if $current[1] == +@bond - 1
    }

    sub direction( [$x, $y] ) {
        ( Down  if @bond[$y + 1][$x].contains: ' ' ) ||
        ( Left  if @bond[$y][$x - 1].contains: ' ' ) ||
        ( Right if @bond[$y][$x + 1].contains: ' ' ) ||
        ( Up    if @bond[$y - 1][$x].defined && @bond[$y - 1][$x].contains: ' ' ) ||
        DeadEnd
    }

    sub move ( $dir, @cur ) {
        my ( $x, $y ) = @cur;
        given $dir {
            when Up    { [$x,--$y].&fill xx 2 }
            when Down  { [$x,++$y].&fill xx 2 }
            when Left  { [--$x,$y].&fill xx 2 }
            when Right { [++$x,$y].&fill xx 2 }
        }
        [$x, $y]
    }

    sub fill ( [$x, $y] ) { @bond[$y;$x].=subst(' ', $water, :g) }
}

sub generate ( $prob = .5 ) {
    @bond = ();
    my $sp = '   ';
    append @bond, [flat '│', ($sp, ' ') xx $geom, $sp, '│'],
                  [flat '├', (h(), '┬') xx $geom, h(), '┤'];
    append @bond, [flat '│', ($sp, v()) xx $geom, $sp, '│'],
                  [flat '├', (h(), '┼') xx $geom, h(), '┤'] for ^$geom;
    append @bond, [flat '│', ($sp, v()) xx $geom, $sp, '│'],
                  [flat '├', (h(), '┴') xx $geom, h(), '┤'],
                  [flat '│', ($sp, ' ') xx $geom, $sp, '│'];

    sub h () { rand < $prob ?? $sp !! '───' }
    sub v () { rand < $prob ?? ' ' !! '│'   }
}
