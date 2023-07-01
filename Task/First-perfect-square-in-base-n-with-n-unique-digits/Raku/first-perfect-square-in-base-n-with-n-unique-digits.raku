#`[

Only search square numbers that have at least N digits;
smaller could not possibly match.

Only bother to use analytics for large N. Finesse takes longer than brute force for small N.

]

unit sub MAIN ($timer = False);

sub first-square (Int $n) {
    my @start = flat '1', '0', (2 ..^ $n)».base: $n;

    if $n > 10 { # analytics
        my $root  = digital-root( @start.join, :base($n) );
        my @roots = (2..$n).map(*²).map: { digital-root($_.base($n), :base($n) ) };
        if $root ∉ @roots {
            my $offset = min(@roots.grep: * > $root ) - $root;
            @start[1+$offset] = $offset ~ @start[1+$offset];
        }
    }

    my $start = @start.join.parse-base($n).sqrt.ceiling;
    my @digits = reverse (^$n)».base: $n;
    my $sq;
    my $now  = now;
    my $time = 0;
    my $sr;
    for $start .. * {
        $sq = .²;
        my $s = $sq.base($n);
        my $f;
        $f = 1 and last unless $s.contains: $_ for @digits;
        if $timer && $n > 19 && $_ %% 1_000_000 {
            $time += now - $now;
            say "N $n:  {$_}² = $sq <$s> : {(now - $now).round(.001)}s" ~
                " : {$time.round(.001)} elapsed";
            $now = now;
        }
        next if $f;
        $sr = $_;
        last
    }
    sprintf( "Base %2d: %13s² == %-30s", $n, $sr.base($n), $sq.base($n) ) ~
        ($timer ?? ($time + now - $now).round(.001) !! '');
}

sub digital-root ($root is copy, :$base = 10) {
    $root = $root.comb.map({:36($_)}).sum.base($base) while $root.chars > 1;
    $root.parse-base($base);
}

say  "First perfect square with N unique digits in base N: ";
say .&first-square for flat
   2 .. 12, # required
  13 .. 16, # optional
  17 .. 19, # stretch
  20, # slow
  21, # pretty fast
  22, # very slow
  23, # don't hold your breath
  24, # slow but not too terrible
  25, # very slow
  26, #   "
;
