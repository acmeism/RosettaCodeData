my $block = '▒';
my $water = '+';
my $pore  = ' ';
my $grid  = 15;
my @site;

$D{$_} = $i++ for qw<DeadEnd Up Right Down Left>;

sub deq { defined $_[0] && $_[0] eq $_[1] }

sub percolate {
    my($prob) = shift || 0.6;
    $site[0] = [($pore) x $grid];
    for my $y (1..$grid) {
        for my $x (0..$grid-1) {
            $site[$y][$x] = rand() < $prob ? $pore : $block;
        }
    }
    $site[$grid + 1] = [($pore) x $grid];
    $site[0][0] = $water;

    my $x = 0;
    my $y = 0;
    my @stack;

    while () {
        if (my $dir = direction($x,$y)) {
            push @stack, [$x,$y];
            ($x,$y) = move($dir, $x, $y)
        } else {
            return 0 unless @stack;
            ($x,$y) = @{pop @stack}
        }
        return 1 if $y > $grid;
    }
}

sub direction {
    my($x, $y) = @_;
    return $D{Down}  if deq($site[$y+1][$x  ], $pore);
    return $D{Right} if deq($site[$y  ][$x+1], $pore);
    return $D{Left}  if deq($site[$y  ][$x-1], $pore);
    return $D{Up}    if deq($site[$y-1][$x  ], $pore);
    return $D{DeadEnd};
}

sub move {
    my($dir,$x,$y) = @_;
    $site[--$y][   $x] = $water if $dir == $D{Up};
    $site[++$y][   $x] = $water if $dir == $D{Down};
    $site[  $y][ --$x] = $water if $dir == $D{Left};
    $site[  $y][ ++$x] = $water if $dir == $D{Right};
    $x, $y
}

my $prob = 0.65;
percolate($prob);

print "Sample percolation at $prob\n";
print join '', @$_, "\n" for @site;
print "\n";

my $tests = 100;
print "Doing $tests trials at each porosity:\n";
my @table;
for my $p (1 .. 10) {
    $p = $p/10;
    my $total = 0;
    $total += percolate($p) for 1..$tests;
    push @table, sprintf "p = %0.1f: %0.2f", $p, $total / $tests
}

print "$_\n" for @table;
