# Usage: GAWK -f MATRIX_MULTIPLICATION.AWK filename
# Separate matrices a and b by a blank line
BEGIN {
    ranka1 = 0; ranka2 = 0
    rankb1 = 0; rankb2 = 0
    matrix = 1 # Indicate first (1) or second (2) matrix
    i = 0
}
NF == 0 {
    if (++matrix > 2) {
        printf("Warning: Ignoring data below line %d.\n", NR)
    }
    i = 0
    next
}
{
    # Store first matrix in a, second matrix in b
    if (matrix == 1) {
        ranka1 = ++i
        ranka2 = max(ranka2, NF)
        for (j = 1; j <= NF; j++)
            a[i,j] = $j
    }
    if (matrix == 2) {
        rankb1 = ++i
        rankb2 = max(rankb2, NF)
        for (j = 1; j <= NF; j++)
            b[i,j] = $j
    }
}
END {
    # Check ranks of a and b
    if ((ranka1 < 1) || (ranka2 < 1) || (rankb1 < 1) || (rankb2 < 1) ||
        (ranka2 != rankb1)) {
        printf("Error: Incompatible ranks (%dx%d)*(%dx%d).\n", ranka1, ranka2, rankb1, rankb2)
        exit
    }
    # Multiplication c = a * b
    for (i = 1; i <= ranka1; i++) {
        for (j = 1; j <= rankb2; j++) {
            c[i,j] = 0
            for (k = 1; k <= ranka2; k++)
                c[i,j] += a[i,k] * b[k,j]
        }
    }
    # Print matrix c
    for (i = 1; i <= ranka1; i++) {
        for (j = 1; j <= rankb2; j++)
            printf("%g%s", c[i,j], j < rankb2 ? " " : "\n")
    }
}
function max(m, n) {
    return m > n ? m : n
}
