my $block = '▒';
my $water = '+';
my $pore  = ' ';
my $grid  = 15;
my @site;

enum Direction <DeadEnd Up Right Down Left>;

say 'Sample percolation at .6';
percolate(.6);
.join.say for @site;
say "\n";

my $tests = 1000;
say "Doing $tests trials at each porosity:";
for .1, .2 ... 1 -> $p {
    printf "p = %0.1f: %0.3f\n", $p, (sum percolate($p) xx $tests) / $tests
}

sub infix:<deq> ( $a, $b ) { $a.defined && ($a eq $b) }

sub percolate ( $prob  = .6 ) {
    @site[0] = [$pore xx $grid];
    @site[$grid + 1] = [$pore xx $grid];

    for ^$grid X 1..$grid -> ($x, $y) {
        @site[$y;$x] = rand < $prob ?? $pore !! $block
    }
    @site[0;0] = $water;

    my @stack;
    my $current = [0;0];

    loop {
        if my $dir = direction( $current ) {
            @stack.push: $current;
            $current = move( $dir, $current )
        }
        else {
            return 0 unless @stack;
            $current = @stack.pop
        }
        return 1 if $current[1] > $grid
    }

    sub direction( [$x, $y] ) {
        (Down  if @site[$y + 1][$x] deq $pore) ||
        (Left  if @site[$y][$x - 1] deq $pore) ||
        (Right if @site[$y][$x + 1] deq $pore) ||
        (Up    if @site[$y - 1][$x] deq $pore) ||
        DeadEnd
    }

    sub move ( $dir, @cur ) {
        my ( $x, $y ) = @cur;
        given $dir {
            when Up    { @site[--$y][$x] = $water }
            when Down  { @site[++$y][$x] = $water }
            when Left  { @site[$y][--$x] = $water }
            when Right { @site[$y][++$x] = $water }
        }
        [$x, $y]
    }
}
