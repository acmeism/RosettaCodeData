#| Recursive, parallel, batch tuned, single-pass, quicksort implementation
sub quicksort-parallel(@a, $batch = 2**9) {
	return @a if @a.elems < 2;

	# separate unsorted input into Order Less, Same and More compared to a random $pivot
	my $pivot = @a.pick;
	my %prt{Order} is default([]) = @a.classify( * cmp $pivot );

	# decide if we sort the Less partition on a new thread
	my $less = %prt{Less}.elems >= $batch
			        ?? start { samewith(%prt{Less}, $batch) }
			        !!         samewith(%prt{Less}, $batch);

	# meanwhile use current thread for sorting the More partition
	my $more = samewith(%prt{More}, $batch);

	# if we went parallel, we need to await the result
	await $less andthen $less = $less.result if $less ~~ Promise;

	# concat all sorted partitions into a list and return
	|$less, |%prt{Same}, |$more;
}
