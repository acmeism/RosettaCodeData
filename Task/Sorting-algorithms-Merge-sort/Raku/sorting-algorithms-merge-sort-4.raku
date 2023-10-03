constant $BATCH-SIZE = 2**10;
my atomicint $worker = $*KERNEL.cpu-cores;

#| Recursive, parallel, tuned, mergesort implementation
proto mergesort-parallel(| --> Positional) {*}
multi mergesort-parallel(@unsorted where @unsorted.elems < 2) { @unsorted }
multi mergesort-parallel(@unsorted where @unsorted.elems == 2) {
    @unsorted[0] after @unsorted[1]
		?? (@unsorted[1], @unsorted[0])
		!! @unsorted
}
multi mergesort-parallel(@unsorted) {
	my $mid = @unsorted.elems div 2;

	# atomically decide if we run left side on a new thread
	my $left-sorted = ⚛$worker > 0 &&
			              $mid > $BATCH-SIZE
						?? (
								$worker⚛--;
								start {
									LEAVE $worker⚛++;
									samewith @unsorted[ 0 ..^ $mid ]
								}
							)
						!! samewith @unsorted[ 0 ..^ $mid ];

	# recursion on the right side using current thread
	my @right-sorted = samewith @unsorted[ $mid ..^ @unsorted.elems ];

	# await calculation of left side
	await $left-sorted andthen $left-sorted = flat $left-sorted.result
        if $left-sorted ~~ Promise;
	my @left-sorted = flat $left-sorted;

	# short cut - in case of no overlapping left and right parts
	return flat @left-sorted, @right-sorted if @left-sorted[*-1] !after @right-sorted[0];
	return flat @right-sorted, @left-sorted if @right-sorted[*-1] !after @left-sorted[0];

	# merge step
	return flat gather {
		take @left-sorted[0] before @right-sorted[0]
				?? @left-sorted.shift
				!! @right-sorted.shift
		     while @left-sorted.elems and @right-sorted.elems;
		take @left-sorted, @right-sorted;
	}
}
