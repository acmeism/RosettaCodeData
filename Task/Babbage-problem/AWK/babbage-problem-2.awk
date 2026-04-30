#!/usr/bin/awk -f
# Quite efficient solution based on modulo arithmetic
# needs 270 square/mod calculations (variable tally)
# to calculate all solutions, and stop if none
BEGIN {
    q = 269696
    if (ARGC > 1) q = ARGV[1]
    # print q ":"
    set[1] = 0
    m = 1
    while (m < q && length(set) > 0) {
        new_set(set, m, q)
        m *= 10
    }
    if (length(set) > 1) {
        asort(set)
        for (i in set) {
            v = set[i]
            printf("%6d^2 -- %12d\n", v, v*v)
        }
        print tally " square/mod calculations"
    } else {
        print "NO SOLUTION"
    }
}

function new_set (old, m, q,        new, mm, qm, i, j, k, l) {
    mm = 10 * m
    qm = q % mm
    for (i in old)
        for (j = 0; j < 10*m; j += m) {
            tally += 1
            k = i + j
            l = (k*k) % mm
            if (l == qm)
                new[k] = k
        }
    # new set in old
    delete old
    for (i in new)
       old[i] = new[i]
    # show(new)
}

function show(set) {
    for (i in set)
        printf("%d ", i)
    print ""
}
