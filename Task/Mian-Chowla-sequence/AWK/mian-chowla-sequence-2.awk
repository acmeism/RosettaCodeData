# helper functions
#
#    determine if a list is empty or not
function isEmpty(a) { for (ii in a) return 0; return 1 }
#    list concatination
function concat(a, b) { for (cc in b) a[cc] = cc }

BEGIN \
{
    mc[0] = 1; sums[2] = 0;      # initialize lists
    for ( i = 1; i < 100; i ++ ) # iterate for each item in result
    {
        for ( j = mc[i-1]+1; ; j ++ ) # iterate thru trial values
        {
            mc[i] = j;           # set trial value into result
            for ( k = 0; k <= i; k ++ ) # test new iteration of sums
            {
                # test trial sum against old sums list
                if ((sum = mc[k] + j) in sums)
                {                # collision, so
                    delete ts;   # toss out any accumulated items,
                    break;       #  and break out to the next j
                }
                ts[sum] = sum;   # (else) accumulate to new sum list
            } # for k
            if ( isEmpty( ts ) ) # nothing to add,
                continue;        #  so try next j
            concat( sums, ts );  # combine new sums to old,
            delete ts;           #  clear out the new,
            break;               #  break out to next i
        } # for j
    } # for i
    # print the sequence
    ps = "Mian Chowla sequence elements %d..%d:\n";
    for ( i = 0; i < 100; i ++ )
    {
        if ( i == 0 )  printf ps, 1, 30;
        if ( i == 90 ) printf "\n\n" ps, 91, 100;
        if ( i < 30 || i >= 90 ) printf "%d ", mc[ i ];
    } # for i
    print "\n"
} # BEGIN
