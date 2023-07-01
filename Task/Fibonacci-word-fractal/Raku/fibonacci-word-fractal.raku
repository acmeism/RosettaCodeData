constant @fib-word = '1', '0', { $^b ~ $^a } ... *;

sub MAIN($m = 17, $scale = 3) {
    (my %world){0}{0} = 1;
    my $loc = 0+0i;
    my $dir = i;
    my $n = 1;

    for @fib-word[$m].comb {
        when '0' {
            step;
            if $n %% 2 { turn-left }
            else { turn-right; }
        }
        $n++;
    }

    braille-graphics %world;

    sub step {
        for ^$scale {
            $loc += $dir;
            %world{$loc.im}{$loc.re} = 1;
        }
    }

    sub turn-left  { $dir *= i; }
    sub turn-right { $dir *= -i; }

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
