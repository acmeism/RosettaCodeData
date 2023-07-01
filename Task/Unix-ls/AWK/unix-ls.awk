# syntax: GAWK -f UNIX_LS.AWK * | SORT
BEGINFILE {
    printf("%s\n",FILENAME)
    nextfile
}
END {
    exit(0)
}
