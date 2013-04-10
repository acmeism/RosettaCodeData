#!/usr/bin/awk -f

BEGIN {
    d[1] = 3.0
    d[2] = 4.0
    d[3] = 1.0
    d[4] = -8.4
    d[5] = 7.2
    d[6] = 4.0
    d[7] = 1.0
    d[8] = 1.2
    showD("Before: ")
    gnomeSortD()
    showD("Sorted: ")
    printf "Median: %f\n", medianD()
    exit
}

function medianD(     len, mid) {
    len = length(d)
    mid = int(len/2) + 1
    if (len % 2) return d[mid]
    else return (d[mid] + d[mid-1]) / 2.0
}

function gnomeSortD(    i) {
    for (i = 2; i <= length(d); i++) {
        if (d[i] < d[i-1]) gnomeSortBackD(i)
    }
}

function gnomeSortBackD(i,     t) {
    for (; i > 1 && d[i] < d[i-1]; i--) {
        t = d[i]
        d[i] = d[i-1]
        d[i-1] = t
    }
}

function showD(p,   i) {
    printf p
    for (i = 1; i <= length(d); i++) {
        printf d[i] " "
    }
    print ""
}
