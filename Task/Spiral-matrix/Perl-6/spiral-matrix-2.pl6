sub MAIN($size as Int) {
    my $t = Turtle.new(dir => east);
    my $counter = 0;
    $t.forward(-1);
    for 0..^ $size -> $ {
	$t.forward;
	$t.lay-egg($counter++);
    }
    for $size-1 ... 1 -> $run {
	$t.turn-right;
	$t.forward, $t.lay-egg($counter++) for 0..^$run;
	$t.turn-right;
	$t.forward, $t.lay-egg($counter++) for 0..^$run;
    }
    $t.showmap;
}
