sub  output( @arr, $max ) {
    my $output = 1;
    for 1..^$max -> $index {
	if @arr[$index] {
	    printf "%4d", $index;
	    say '' if $output++ %%  10;
	}
    }
    say '';
}

sub MAIN ( Int :$doors = 100 ) {
    my $doorcount = $doors + 1;
    my @door[$doorcount] = 0 xx ($doorcount);

    INDEX:
    for 1...^$doorcount -> $index {
        # flip door $index & its multiples, up to last door.
        #
	for ($index, * + $index ... *)[^$doors] -> $multiple {
	    next INDEX if $multiple > $doors;
	    @door[$multiple] =  @door[$multiple] ?? 0 !! 1;
	}
    }
    output @door, $doors+1;
}
