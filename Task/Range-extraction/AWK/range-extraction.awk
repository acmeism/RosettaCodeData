#!/usr/bin/awk -f

BEGIN {
    delete sequence
    delete range

    seqStr = "0,1,2,4,6,7,8,11,12,14,15,16,17,18,19,20,21,22,23,24,"
    seqStr = seqStr "25,27,28,29,30,31,32,33,35,36,37,38,39"
    print "Sequence: " seqStr
    fillSequence(seqStr)
    rangeExtract()
    showRange()
    exit
}

function rangeExtract(    runStart, runLen) {
    delete range
    runStart = 1
    while(runStart <= length(sequence)) {
        runLen = getSeqRunLen(runStart)
        addRange(runStart, runLen)
        runStart += runLen
    }
}

function getSeqRunLen(startPos,    pos) {
    for (pos = startPos; pos < length(sequence); pos++) {
        if (sequence[pos] + 1 != sequence[pos + 1]) break;
    }
    return pos - startPos + 1;
}

function addRange(startPos, len,    str) {
    if (len == 1) str = sequence[startPos]
    else if (len == 2) str = sequence[startPos] "," sequence[startPos + 1]
    else str = sequence[startPos] "-" sequence[startPos + len - 1]
    range[length(range) + 1] = str
}

function showRange(    r) {
    printf "  Ranges: "
    for (r = 1; r <= length(range); r++) {
        if (r > 1) printf ","
        printf range[r]
    }
    printf "\n"
}

function fillSequence(seqStr,    n, s) {
    n = split(seqStr,a,/[,]+/)
    for (s = 1; s <= n; s++) {
        sequence[s] = a[s]
    }
}
