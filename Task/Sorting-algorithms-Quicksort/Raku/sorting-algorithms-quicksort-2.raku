#| Recursive, parallel, random pivot, single-pass, quicksort implementation
multi quicksort-parallel-naive(\a where a.elems < 2) { a }
multi quicksort-parallel-naive(\a, \pivot = a.pick) {
	my %prt{Order} is default([]) = a.classify: * cmp pivot;
	my Promise $less = start { samewith(%prt{Less}) }
	my $more = samewith(%prt{More});
	await $less andthen |$less.result, |%prt{Same}, |$more;
}
