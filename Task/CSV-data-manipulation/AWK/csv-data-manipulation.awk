#!/usr/bin/awk -f
BEGIN { FS = OFS = "," }
NR==1 {
    print $0, "SUM"
    next
}
{
    sum = 0
    for (i=1; i<=NF; i++) {	
        sum += $i
    }
    print $0, sum
}
