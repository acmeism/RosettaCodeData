# syntax: GAWK -f WRITE_ENTIRE_FILE.AWK
BEGIN {
    dev = "FILENAME.TXT"
    print("(Over)write a file so that it contains a string.") >dev
    close(dev)
    exit(0)
}
