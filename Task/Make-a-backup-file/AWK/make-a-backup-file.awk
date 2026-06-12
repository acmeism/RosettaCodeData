# syntax: GAWK -f MAKE_A_BACKUP_FILE.AWK filename(s)
# see: http://www.gnu.org/software/gawk/manual/gawk.html#Extension-Sample-Inplace
@load "inplace"
BEGIN {
    INPLACE_SUFFIX = ".BAK"
}
BEGINFILE {
    inplace_begin(FILENAME,INPLACE_SUFFIX)
}
1 # rewrite file unchanged
ENDFILE {
    inplace_end(FILENAME,INPLACE_SUFFIX)
}
END {
    exit(0)
}
