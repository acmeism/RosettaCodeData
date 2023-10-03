#| Recursive, naive parallel, mergesort implementation
proto mergesort-parallel-naive(| --> Positional) {*}
multi mergesort-parallel-naive(@unsorted where @unsorted.elems < 2) { @unsorted }
multi mergesort-parallel-naive(@unsorted where @unsorted.elems == 2) {
	@unsorted[0] after @unsorted[1]
		?? (@unsorted[1], @unsorted[0])
		!! @unsorted
}
multi mergesort-parallel-naive(@unsorted) {
	my $mid = @unsorted.elems div 2;
	my Promise $left-sorted = start { flat samewith @unsorted[  0 ..^ $mid ] };
	my @right-sorted = flat samewith @unsorted[ $mid ..^ @unsorted.elems ];

	await $left-sorted andthen my @left-sorted = $left-sorted.result;

    return flat @left-sorted, @right-sorted if @left-sorted[*-1] !after @right-sorted[0];
	return flat @right-sorted, @left-sorted if @right-sorted[*-1] !after @left-sorted[0];
	
    return flat gather {
		take @left-sorted[0] before @right-sorted[0]
				?? @left-sorted.shift
				!! @right-sorted.shift
		while @left-sorted.elems and @right-sorted.elems;
		take @left-sorted, @right-sorted;
	}
}
