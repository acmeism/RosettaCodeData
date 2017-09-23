my @perc;
my $fill = 'x';

enum Direction <DeadEnd Up Right Down Left>;

my $𝘒 = perctest(15);
.fmt("%-2s").say for @perc;
say "𝘱 = 0.5, 𝘕 = 15, 𝘒 = $𝘒\n";

my $trials = 5;
for 10, 30, 100, 300, 1000 -> $𝘕 {
    my $𝘒 = ( [+] perctest($𝘕) xx $trials ) / $trials;
    say "𝘱 = 0.5, trials = $trials, 𝘕 = $𝘕, 𝘒 = $𝘒";
}

sub infix:<deq> ( $a, $b ) { $a.defined && ($a eq $b) }

sub perctest ( $grid ) {
    generate $grid;
    my $block = 1;
    for ^$grid X ^$grid -> ($y, $x) {
        fill( [$x, $y], $block++ ) if @perc[$y; $x] eq $fill
    }
    ($block - 1) / $grid²;
}

sub generate ( $grid ) {
    @perc = ();
    @perc.push: [ ( rand < .5 ?? '.' !! $fill ) xx $grid ] for ^$grid;
}

sub fill ( @cur, $block ) {
    @perc[@cur[1]; @cur[0]] = $block;
    my @stack;
    my $current = @cur;

    loop {
        if my $dir = direction( $current ) {
            @stack.push: $current;
            $current = move $dir, $current, $block
        }
        else {
            return unless @stack;
            $current = @stack.pop
        }
    }

    sub direction( [$x, $y] ) {
        ( Down  if @perc[$y + 1][$x] deq $fill ) ||
        ( Left  if @perc[$y][$x - 1] deq $fill ) ||
        ( Right if @perc[$y][$x + 1] deq $fill ) ||
        ( Up    if @perc[$y - 1][$x] deq $fill ) ||
        DeadEnd
    }

    sub move ( $dir, @cur, $block ) {
        my ( $x, $y ) = @cur;
        given $dir {
            when Up    { @perc[--$y; $x] = $block }
            when Down  { @perc[++$y; $x] = $block }
            when Left  { @perc[$y; --$x] = $block }
            when Right { @perc[$y; ++$x] = $block }
        }
        [$x, $y]
    }
}
