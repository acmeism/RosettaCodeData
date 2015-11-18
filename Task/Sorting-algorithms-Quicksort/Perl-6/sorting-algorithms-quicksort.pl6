# Empty list sorts to the empty list
 multi quicksort([]) { () }

 # Otherwise, extract first item as pivot...
 multi quicksort([$pivot, *@rest]) {
     # Partition.
     my $before := @rest.grep(* before $pivot);
     my $after  := @rest.grep(* !before $pivot);

     # Sort the partitions.
     flat quicksort($before), $pivot, quicksort($after)
 }
