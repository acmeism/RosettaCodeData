for 3..* -> $base {
    say "Starting base $base...";
    my @stems = grep { is-prime($_, 100)}, ^$base;
    my @runoff;
    for 1 .. * -> $digits {
      print ' ', @stems.elems;
      my @new;
      my $place = $base ** $digits;
      my $tries = 1;
      for @stems -> $stem {
	for 1 ..^ $base -> $digit {
	  my $new = $digit * $place + $stem;
	  @new.push($new) if is-prime($new, $tries);
        }
      }
      last unless @new;
      push @runoff, @stems if @new < @stems and @new < 100;
      @stems = @new;
    }
    push @runoff, @stems;
    say "\n  Finalists: ", +@runoff;

    for @runoff.sort(-*) -> $finalist {
	my $b = $finalist.base($base);
	say "  Checking :$base\<", $b, '>';
	my $ok = True;
	for $base ** 2, $base ** 3, $base ** 4 ... $base ** $b.chars -> $place {
	    my $f = $finalist % $place;
	    if not is-prime($f, 100) {
		say "    Oops, :$base\<", $f.base($base), '> is not a prime!!!';
		$ok = False;
		last;
	    }
	}
	next unless $ok;

	say "  Largest ltp in base $base = $finalist";
	last;
    }
}
