cocktailSort2: procedure expose items.
    nn = items.0 - 1  /*N:  the number of items in items.*/
    do until done
        done = 1
        do j = 1 for nn
            jp = j + 1        /* Rexx doesn't allow "items.(j+1)", so use this instead. */
            if items.j > items.jp  then ,
			    parse value 0 items.j items.jp with done items.jp items.j /* swap items.j and items.jp, and set done to 0 */
        end /*j*/
        if done then leave                /*Did swaps?   Then we're done.*/
        do k = nn for nn by -1
            kp = k + 1        /* Rexx doesn't allow "items.(k+1)", so use this instead. */
            if items.k > items.kp  then ,
			    parse value 0 items.k items.kp with done items.kp items.k /* swap items.k and items.kp, and set done to 0 */
        end /*k*/
    end /*until*/

	return
