$fill = 'x';
$D{$_} = $i++ for qw<DeadEnd Up Right Down Left>;

sub deq { defined $_[0] && $_[0] eq $_[1] }

sub perctest {
    my($grid) = @_;
    generate($grid);
    my $block = 1;
    for my $y (0..$grid-1) {
        for my $x (0..$grid-1) {
            fill($x, $y, $block++) if $perc[$y][$x] eq $fill
        }
    }
    ($block - 1) / $grid**2;
}

sub generate {
    my($grid) = @_;
    for my $y (0..$grid-1) {
        for my $x (0..$grid-1) {
            $perc[$y][$x] = rand() < .5 ? '.' : $fill;
        }
    }
}

sub fill {
    my($x, $y, $block) = @_;
    $perc[$y][$x] = $block;
    my @stack;
    while (1) {
        if (my $dir = direction( $x, $y )) {
            push @stack, [$x, $y];
            ($x,$y) = move($dir, $x, $y, $block)
        } else {
            return unless @stack;
            ($x,$y) = @{pop @stack};
        }
    }
}

sub direction {
    my($x, $y) = @_;
    return $D{Down}  if deq($perc[$y+1][$x  ], $fill);
    return $D{Left}  if deq($perc[$y  ][$x-1], $fill);
    return $D{Right} if deq($perc[$y  ][$x+1], $fill);
    return $D{Up}    if deq($perc[$y-1][$x  ], $fill);
    return $D{DeadEnd};
}

sub move {
    my($dir,$x,$y,$block) = @_;
    $perc[--$y][   $x] = $block if $dir == $D{Up};
    $perc[++$y][   $x] = $block if $dir == $D{Down};
    $perc[  $y][ --$x] = $block if $dir == $D{Left};
    $perc[  $y][ ++$x] = $block if $dir == $D{Right};
    ($x, $y)
}

my $K = perctest(15);
for my $row (@perc) {
    printf "%3s", $_ for @$row;
    print "\n";
}
printf  "𝘱 = 0.5, 𝘕 = 15, 𝘒 = %.4f\n\n", $K;

$trials = 5;
for $N (10, 30, 100, 300, 1000) {
    my $total = 0;
    $total += perctest($N) for 1..$trials;
    printf "𝘱 = 0.5, trials = $trials, 𝘕 = %4d, 𝘒 = %.4f\n", $N, $total / $trials;
}
