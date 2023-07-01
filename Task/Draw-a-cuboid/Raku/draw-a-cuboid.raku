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

sub cuboid ( [$x, $y, $z] ) {
    my \x = $x * 4;
    my \y = $y * 4;
    my \z = $z * 2;
    my %t;
    sub horz ($X, $Y) { %t{$Y     }{$X + $_} = True for 0 .. x }
    sub vert ($X, $Y) { %t{$Y + $_}{$X     } = True for 0 .. y }
    sub diag ($X, $Y) { %t{$Y - $_}{$X + $_} = True for 0 .. z }

    horz(0, z); horz(z, 0); horz(  0, z+y);
    vert(0, z); vert(x, z); vert(z+x,   0);
    diag(0, z); diag(x, z); diag(  x, z+y);

    say "[$x, $y, $z]";
    braille-graphics %t;
}

cuboid $_ for [2,3,4], [3,4,2], [4,2,3], [1,1,1], [8,1,1], [1,8,1], [1,1,8];
