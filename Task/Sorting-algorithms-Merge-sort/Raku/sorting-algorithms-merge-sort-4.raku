#| Recursive, batch tuned multi-thread, mergesort implementation
sub mergesort-parallel ( @a, $batch = 2**9 ) {
	return @a if @a <= 1;

	my $m = @a.elems div 2;

	# recursion step
	my @l = $m >= $batch
			  ?? start { samewith @a[ 0 ..^ $m ], $batch }
			  !!         samewith @a[ 0 ..^ $m ], $batch ;

	# meanwhile recursively sort right side
	my @r = samewith @a[ $m ..^ @a ], $batch;

	# if we went parallel on left side, we need to await the result
	await @l[0] andthen @l = @l[0].result if @l[0] ~~ Promise;

	# short cut - in case of no overlapping left and right parts
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
