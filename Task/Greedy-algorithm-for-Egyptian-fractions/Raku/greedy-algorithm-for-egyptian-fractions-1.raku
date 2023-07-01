role Egyptian {
    method gist {
	join ' + ',
	    ("[{self.floor}]" if self.abs >= 1),
	    map {"1/$_"}, self.denominators;
    }
    method denominators {
	my ($x, $y) = self.nude;
	$x %= $y;
	my @denom = gather ($x, $y) = -$y % $x, $y * take ($y / $x).ceiling
	    while $x;
    }
}

say .nude.join('/'), " = ", $_ but Egyptian for 43/48, 5/121, 2014/59;

my @sample = map { $_ => .denominators },
    grep * < 1,
        map {$_ but Egyptian},
            (2 .. 99 X/ 2 .. 99);

say .key.nude.join("/"),
    " has max denominator, namely ",
    .value.max
        given max :by(*.value.max), @sample;

say .key.nude.join("/"),
    " has max number of denominators, namely ",
    .value.elems
        given max :by(*.value.elems), @sample;
