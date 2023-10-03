#| 7-Line, recursive, parallel, single-pass, quicksort implementation
multi seven-line-quicksort-parallel(@unsorted where @unsorted.elems < 2) { @unsorted }
multi seven-line-quicksort-parallel(@unsorted) {
	my $pivot = @unsorted.pick;
	my %partitions{Order} is default([]) = @unsorted.classify( * cmp $pivot );
	my Promise $less = start { samewith(%partitions{Less}) }
	my $more = samewith(%partitions{More});
	await $less andthen |$less.result, |%partitions{Same}, |$more;
}
