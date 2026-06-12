sub cycle_sort ( @nums ) {
    my $writes = 0;

    # Loop through the array to find cycles to rotate.
    for @nums.kv -> $cycle_start, $item is copy {

        # Find where to put the item.
        my $pos = $cycle_start
                + @nums[ $cycle_start ^.. * ].grep: * < $item;

        # If the item is already there, this is not a cycle.
        next if $pos == $cycle_start;

        # Otherwise, put the item there or right after any duplicates.
        $pos++ while $item == @nums[$pos];
        ( @nums[$pos], $item ) .= reverse;
        $writes++;

        # Rotate the rest of the cycle.
        while $pos != $cycle_start {

            # Find where to put the item.
            $pos = $cycle_start
                 + @nums[ $cycle_start ^.. * ].grep: * < $item;

            # Put the item there or right after any duplicates.
            $pos++ while $item == @nums[$pos];
            ( @nums[$pos], $item ) .= reverse;
            $writes++;
        }
    }

    return $writes;
}

my @a = <0 1 2 2 2 2 1 9 3.5 5 8 4 7 0 6>;

say @a;
say 'writes ', cycle_sort(@a);
say @a;
