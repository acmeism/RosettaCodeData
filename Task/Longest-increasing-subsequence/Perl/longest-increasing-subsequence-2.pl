sub lis {
    my @pileTops;
    # sort into piles
    foreach my $x (@_) {
	# binary search
	my $low = 0, $high = $#pileTops;
	while ($low <= $high) {
	    my $mid = int(($low + $high) / 2);
	    if ($pileTops[$mid]{val} >= $x) {
	        $high = $mid - 1;
	    } else {
	        $low = $mid + 1;
	    }
	}
	my $i = $low;
	my $node = {val => $x};
        $node->{back} = $pileTops[$i-1] if $i != 0;
	$pileTops[$i] = $node;
    }
    my @result;
    for (my $node = $pileTops[-1]; $node; $node = $node->{back}) {
        push @result, $node->{val};
    }

    return reverse @result;
}

foreach my $r ([3, 2, 6, 4, 5, 1],
	       [0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15]) {
    my @d = @$r;
    my @lis = lis(@d);
    print "an L.I.S. of [@d] is [@lis]\n";

}
