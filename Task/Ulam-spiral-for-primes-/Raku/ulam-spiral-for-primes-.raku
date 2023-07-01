sub MAIN($max = 160, $start = 1) {
    (my %world){0}{0} = 0;
    my ($n, $dir, $side, $loc) = $start, 1, 0, 0+0i;

    while ++$side < $max {
	step for ^$side; turn-left;
	step for ^$side; turn-left;
    }

    braille-graphics %world;

    sub step {
	$loc += $dir;
	%world{$loc.im}{$loc.re} = $n if (++$n).is-prime;
    }

    sub turn-left  { $dir ×= -i }
    sub turn-right { $dir ×=  i }
}

sub braille-graphics (%a) {
    my ($y-lo, $y-hi, $x-lo, $x-hi);
    for %a.keys.map(+*) -> \y {
        for %a{y}.keys.map(+*) -> \x {
            $y-lo min= y; $y-hi max= y;
            $x-lo min= x; $x-hi max= x;
        }
    }

    for $y-lo, $y-lo + 4 ...^ $y-hi -> \y {
	for $x-lo, $x-lo + 2 ...^ $x-hi -> \x {
	    my $cell = 0x2800;
            $cell += 2⁰ if %a{y + 0}{x + 0};
            $cell += 2¹ if %a{y + 1}{x + 0};
            $cell += 2² if %a{y + 2}{x + 0};
            $cell += 2³ if %a{y + 0}{x + 1};
            $cell += 2⁴ if %a{y + 1}{x + 1};
            $cell += 2⁵ if %a{y + 2}{x + 1};
            $cell += 2⁶ if %a{y + 3}{x + 0};
            $cell += 2⁷ if %a{y + 3}{x + 1};
            print chr($cell);
	}
	print "\n";
    }
}
