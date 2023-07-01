sub repeat (&f, $n) { f() xx $n };

sub example { say rand }

repeat(&example, 3);
