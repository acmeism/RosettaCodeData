sub infix:<M> (@x, @y) {
    gather {
	while @x and @y {
	    take do given @x[0] cmp @y[0] {
		when Increase { @x.shift }
		when Decrease { @y.shift }
		when Same     { @x.shift, @y.shift }
	    }
	}
	take @x, @y;
    }
}

sub strand (@x is rw) {
    my $prev = -Inf;
    my $i = 0;
    gather while $i < @x {
	if @x[$i] before $prev {
	    $i++;
        }
        else {
            take $prev = splice(@x, $i, 1)[0];
	}
    }
}

sub strand_sort (@x is copy) {
    my @out;
    @out M= strand(@x) while @x;
    @out;
}

my @a = (^100).roll(10);
say "Before @a[]";
@a = strand_sort(@a);
say "After  @a[]";

@a = <The quick brown fox jumps over the lazy dog>;
say "Before @a[]";
@a = strand_sort(@a);
say "After  @a[]";
