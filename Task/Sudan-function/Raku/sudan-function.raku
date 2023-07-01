multi F (0, $x, $y) { $x + $y }
multi F ($n where * > 0, $x, 0) { $x }
multi F ($n, $x, $y) { F($n-1, F($n, $x, $y-1), F($n, $x, $y-1) + $y) }

# Testing
for 0, 6, 1, 15 -> $f, $g {
    my @range = ^$g;
    say "\{|class=\"wikitable\"\n", "|+ F\<sub>$f\</sub> (x,y)\n" ~ '!x\y!!', join '!!', @range;
    -> $r { say "|-\n" ~ '|' ~ join '||', $r, @range.map:{ F($f, $r, $_) } } for @range;
    say( "|}" );
}
