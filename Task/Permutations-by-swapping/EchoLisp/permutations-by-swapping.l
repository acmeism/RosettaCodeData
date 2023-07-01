(lib 'list)

(for/fold (sign 1) ((σ (in-permutations 4)) (count 100))
    (printf "perm: %a count:%4d sign:%4d" σ count sign) (* sign -1))

perm: (0 1 2 3) count:   0 sign:   1
perm: (0 1 3 2) count:   1 sign:  -1
perm: (0 3 1 2) count:   2 sign:   1
perm: (3 0 1 2) count:   3 sign:  -1
perm: (3 0 2 1) count:   4 sign:   1
perm: (0 3 2 1) count:   5 sign:  -1
perm: (0 2 3 1) count:   6 sign:   1
perm: (0 2 1 3) count:   7 sign:  -1
perm: (2 0 1 3) count:   8 sign:   1
perm: (2 0 3 1) count:   9 sign:  -1
perm: (2 3 0 1) count:  10 sign:   1
perm: (3 2 0 1) count:  11 sign:  -1
perm: (3 2 1 0) count:  12 sign:   1
perm: (2 3 1 0) count:  13 sign:  -1
perm: (2 1 3 0) count:  14 sign:   1
perm: (2 1 0 3) count:  15 sign:  -1
perm: (1 2 0 3) count:  16 sign:   1
perm: (1 2 3 0) count:  17 sign:  -1
perm: (1 3 2 0) count:  18 sign:   1
perm: (3 1 2 0) count:  19 sign:  -1
perm: (3 1 0 2) count:  20 sign:   1
perm: (1 3 0 2) count:  21 sign:  -1
perm: (1 0 3 2) count:  22 sign:   1
perm: (1 0 2 3) count:  23 sign:  -1
