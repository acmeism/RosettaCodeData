#| Recursive, single-thread, random pivot, single-pass, quicksort implementation
multi quicksort(\a where a.elems < 2) { a }
multi quicksort(\a, \pivot = a.pick) {
	my %prt{Order} is default([]) = a.classify: * cmp pivot;
	|samewith(%prt{Less}), |%prt{Same}, |samewith(%prt{More})
}
