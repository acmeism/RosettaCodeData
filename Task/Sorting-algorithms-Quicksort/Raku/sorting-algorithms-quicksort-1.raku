#| Recursive, single-thread, single-pass, quicksort implementation
multi quicksort(@unsorted where @unsorted.elems < 2) { @unsorted }
multi quicksort(@unsorted) {
	my $pivot = @unsorted.pick;
	my %class{Order} is default([]) = @unsorted.classify: * cmp $pivot;
	|samewith(%class{Less}), |%class{Same}, |samewith(%class{More})
}
