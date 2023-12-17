#| Recursive, single-thread, mergesort implementation
sub mergesort ( @a ) {
	return @a if @a <= 1;

	# recursion step
	my $m = @a.elems div 2;
	my @l = samewith @a[  0 ..^ $m ];
	my @r = samewith @a[ $m ..^ @a ];

	# short cut - in case of no overlapping in left and right parts
	return flat @l, @r if @l[*-1] !after @r[0];
	return flat @r, @l if @r[*-1] !after @l[0];

	# merge step
	return flat gather {
		take @l[0] before @r[0]
				?? @l.shift
				!! @r.shift
		     while @l and @r;

		take @l, @r;
	}
}
