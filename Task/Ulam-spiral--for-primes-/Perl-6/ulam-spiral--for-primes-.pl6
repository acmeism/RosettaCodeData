sub MAIN($max = 160, $start = 1) {
    (my %world){0}{0} = 0;
    my $loc = 0+0i;
    my $dir = 1;
    my $n = $start;
    my $side = 0;

    while ++$side < $max {
	step for ^$side;
	turn-left;
	step for ^$side;
	turn-left;
    }

    braille-graphics %world;

    sub step {
	$loc += $dir;
	%world{$loc.im}{$loc.re} = $n if (++$n).is-prime;
    }

    sub turn-left  { $dir *= -i; }
    sub turn-right { $dir *= i; }

}

sub braille-graphics (%a) {
    my ($ylo, $yhi, $xlo, $xhi);
    for %a.keys -> $y {
	$ylo min= +$y; $yhi max= +$y;
	for %a{$y}.keys -> $x {
	    $xlo min= +$x; $xhi max= +$x;
	}
    }

    for $ylo, $ylo + 4 ...^ * > $yhi -> \y {
	for $xlo, $xlo + 2 ...^ * > $xhi -> \x {
	    my $cell = 0x2800;
	    $cell += 1   if %a{y + 0}{x + 0};
	    $cell += 2   if %a{y + 1}{x + 0};
	    $cell += 4   if %a{y + 2}{x + 0};
	    $cell += 8   if %a{y + 0}{x + 1};
	    $cell += 16  if %a{y + 1}{x + 1};
	    $cell += 32  if %a{y + 2}{x + 1};
	    $cell += 64  if %a{y + 3}{x + 0};
	    $cell += 128 if %a{y + 3}{x + 1};
	    print chr($cell);
	}
	print "\n";
    }
}
