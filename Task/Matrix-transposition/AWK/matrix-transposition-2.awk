# Usage: GAWK -f MATRIX_TRANSPOSITION.AWK filename
{
    i = NR
    for (j = 1; j <= NF; j++) {
        a[i,j] = $j
    }
    ranka1 = i
    ranka2 = max(ranka2, NF)
}
END {
    rankb1 = ranka2
    rankb2 = ranka1
    b[rankb1, rankb2] = 0
    transpose_matrix(b, a)
    for (i = 1; i <= rankb1; i++) {
        for (j = 1; j <= rankb2; j++) {
            printf("%g%c", b[i,j], j < rankb2 ? " " : "\n");
        }
    }
}
function transpose_matrix(target, source,     key, idx) {
    for (key in source) {
        split(key, idx, SUBSEP)
        target[idx[2], idx[1]] = source[idx[1], idx[2]]
    }
}
function max(m, n) {
    return m > n ? m : n
}
