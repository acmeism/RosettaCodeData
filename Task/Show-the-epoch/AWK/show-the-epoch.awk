# syntax: GAWK -f SHOW_THE_EPOCH.AWK
# requires GNU Awk 4.0.1 or later
BEGIN {
    print(strftime("%Y-%m-%d %H:%M:%S",0,1))
    exit(0)
}
