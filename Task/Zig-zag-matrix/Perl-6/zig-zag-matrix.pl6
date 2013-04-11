sub MAIN($size as Int) {
    my $t = Turtle.new(dir => northeast);
    my $counter = 0;
    for 1 ..^ $size -> $run {
	for ^$run {
	    $t.lay-egg($counter++);
	    $t.forward;
	}
	my $yaw = $run %% 2 ?? -1 !! 1;
	$t.turn-right($yaw * 135); $t.forward; $t.turn-right($yaw * 45);
    }
    for $size ... 1 -> $run {
	for ^$run -> $ {
	    $t.lay-egg($counter++);
	    $t.forward;
	}
	$t.turn-left(180); $t.forward;
	my $yaw = $run %% 2 ?? 1 !! -1;
	$t.turn-right($yaw * 45); $t.forward; $t.turn-left($yaw * 45);
    }
    $t.showmap;
}
