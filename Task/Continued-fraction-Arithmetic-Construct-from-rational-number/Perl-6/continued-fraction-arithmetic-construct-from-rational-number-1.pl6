sub r2cf(Rat $x is copy) {
    gather loop {
	$x -= take $x.floor;
	last unless $x > 0;
	$x = 1 / $x;
    }
}

say r2cf(.Rat) for <1/2 3 23/8 13/11 22/7 1.41 1.4142136>;
