sub luck(\a,\b) {
    gather {
	my @taken = take a;
	my @rotor;
	my $i = b;

	loop {
	    loop (my $j = 0; $j < @rotor; $j++) {
		--@rotor[$j] or last;
	    }
	    if $j < @rotor {
		@rotor[$j] = @taken[$j+1];
	    }
	    else {
		push @taken, take $i;
		push @rotor, $i - @taken;
	    }
	    $i += 2;
	}
    }
}

constant @lucky = luck(1,3);
constant @evenlucky = luck(2,4);

subset Luck where m:i/^ 'even'? 'lucky' $/;

multi MAIN (Int $num where * > 0) {
    say @lucky[$num-1];
}

multi MAIN (Int $num where * > 0, ',', Luck $howlucky = 'lucky') {
    say @::(lc $howlucky)[$num-1];
}

multi MAIN (Int $first where * > 0, Int $last where * > 0, Luck $howlucky = 'lucky') {
    say @::(lc $howlucky)[$first-1 .. $last - 1];
}

multi MAIN (Int $min where * > 0, Int $neg-max where * < 0, Luck $howlucky = 'lucky') {
    say grep * >= $min, (@::(lc $howlucky) ...^ * > abs $neg-max);
}
