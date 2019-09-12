# syntax: GAWK -f MATRIX_TRANSPOSITION.AWK filename
{   if (NF > nf) {
        nf = NF
    }
    for (i=1; i<=nf; i++) {
        row[i] = row[i] $i " "
    }
}
END {
    for (i=1; i<=nf; i++) {
        printf("%s\n",row[i])
    }
    exit(0)
}
