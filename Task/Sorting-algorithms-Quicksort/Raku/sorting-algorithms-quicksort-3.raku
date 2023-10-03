constant $BATCH-SIZE = 2**10;
my atomicint $worker = $*KERNEL.cpu-cores;
#| Recursive, parallel, tuned, single-pass, quicksort implementation
proto quicksort-parallel(| --> Positional) {*}
multi quicksort-parallel(@unsorted where @unsorted.elems < 2) { @unsorted }
multi quicksort-parallel(@unsorted) {
	# separate unsorted input into Order Less, Same and More compared to a random $pivot
	my $pivot = @unsorted.pick;
	my %partitions{Order} is default([]) = @unsorted.classify( * cmp $pivot );

	# atomically decide if we sort the Less partition on a new thread
	my $less = ⚛$worker > 0 &&
			    %partitions{Less}.elems > $BATCH-SIZE
			        ?? (
			              $worker⚛--;
			              start {
				                   LEAVE $worker⚛++;
				                   samewith(%partitions{Less})
			              }
			            )
			        !! samewith(%partitions{Less});

	# meanwhile use current thread for sorting the More partition
	my $more = samewith(%partitions{More});

	# if we went parallel, we need to await the result
	await $less andthen $less = $less.result if $less ~~ Promise;

	# concat all sorted partitions into a list and return
	|$less, |%partitions{Same}, |$more;
}
