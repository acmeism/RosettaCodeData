#!/usr/bin/gawk -f
# Solve the Eight Queens Puzzle
#    Inspired by Raymond Hettinger [https://code.activestate.com/recipes/576647/]
#    Just the vector of row positions per column is kept,
#    and filled with all possibilities from left to right recursively,
#    then checked against the columns left from the current one:
#    - is a queen in the same row
#    - is a queen in the digonal
#    - is a queen in the reverse diagonal
BEGIN {
    dim = ARGC < 2 ? 8 : ARGV[1]
    # make vec an array
    vec[1] = 0
    # scan for a solution
    if (tryqueen(1, vec, dim))
        result(vec, dim)
    else
        print "No solution with " dim " queens."
}

# try if a queen can be set in column (col)
function tryqueen(col, vec, dim,        new)  {
    for (new = 1; new <= dim; ++new) {
        # check all previous columns
        if (noconflict(new, col, vec, dim)) {
            vec[col] = new
            if (col == dim)
                return 1
            # must try next column(s)
           if (tryqueen(col+1, vec, dim))
                return 1
        }
    }
    # all tested, failed
    return 0
}

#  check if setting the queen (new) in column (col) is ok
#  by checking the previous colums conflicts
function noconflict(new, col, vec, dim,    j) {
    for (j = 1; j < col; j++) {
        if (vec[j] == new)
            return 0    # same row
        if (vec[j] == new - col + j)
            return 0        # diagonal conflict
        if (vec[j] == new + col - j)
            return 0        # reverse diagonal conflict
    }
    # no test failed, no conflict
    return 1
}

# print matrix
function result(vec, dim,    row, col, sep, lne) {
    # print the solution vector
    for (row  = 1; row <= dim; ++row)
        printf " %d", vec[row]
    print

    # print a board matrix
    for (row = 1; row <= dim; ++row) {
        lne = "|"
        for (col = 1; col <= dim; ++col) {
            if (row == vec[col])
                lne = lne "Q|"
            else
                lne = lne "_|"
        }
        print lne
    }
}
