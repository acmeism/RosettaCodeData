my @bond;
my $grid = 10;
my $water = '▒';
$D{$_} = $i++ for qw<DeadEnd Up Right Down Left>;

sub percolate {
    generate(shift || 0.6);
    fill(my $x = 1,my $y = 0);
    my @stack;

    while () {
        if (my $dir = direction($x,$y)) {
            push @stack, [$x,$y];
            ($x,$y) = move($dir, $x, $y)
        } else {
            return 0 unless @stack;
            ($x,$y) = @{pop @stack}
        }
        return 1 if $y == $#bond;
    }
}

sub direction {
    my($x, $y) = @_;
    return $D{Down}  if $bond[$y+1][$x  ] =~ / /;
    return $D{Left}  if $bond[$y  ][$x-1] =~ / /;
    return $D{Right} if $bond[$y  ][$x+1] =~ / /;
    return $D{Up}    if defined $bond[$y-1][$x  ] && $bond[$y-1][$x] =~ / /;
    return $D{DeadEnd}
}

sub move {
    my($dir,$x,$y) = @_;
    fill(  $x,--$y), fill(  $x,--$y) if $dir == $D{Up};
    fill(  $x,++$y), fill(  $x,++$y) if $dir == $D{Down};
    fill(--$x,  $y), fill(--$x,  $y) if $dir == $D{Left};
    fill(++$x,  $y), fill(++$x,  $y) if $dir == $D{Right};
    $x, $y
}

sub fill {
    my($x, $y) = @_;
    $bond[$y][$x] =~ s/ /$water/g
}

sub generate {
    our($prob) = shift || 0.5;
    @bond = ();
    our $sp = '   ';
    push @bond, ['│', ($sp, ' ') x ($grid-1), $sp, '│'],
                ['├', hx('┬'), h(), '┤'];
    push @bond, ['│', vx(   ), $sp, '│'],
                ['├', hx('┼'), h(), '┤'] for 1..$grid-1;
    push @bond, ['│', vx(   ), $sp, '│'],
                ['├', hx('┴'), h(), '┤'],
                ['│', ($sp, ' ') x ($grid-1), $sp, '│'];

    sub hx { my($c)=@_; my @l; push @l, (h(),$c) for 1..$grid-1; return @l; }
    sub vx {            my @l; push @l, $sp, v() for 1..$grid-1; return @l; }
    sub h { rand() < $prob ? $sp : '───' }
    sub v { rand() < $prob ? ' ' : '│'   }
}

print "Sample percolation at .6\n";
percolate(.6);
for my $row (@bond) {
    my $line = '';
    $line .= join '', $_ for @$row;
    print "$line\n";
}

my $tests = 100;
print "Doing $tests trials at each porosity:\n";
my @table;
for my $p (1 .. 10) {
    $p = $p/10;
    my $total = 0;
    $total += percolate($p) for 1..$tests;
    printf "p = %0.1f: %0.2f\n", $p, $total / $tests
}
