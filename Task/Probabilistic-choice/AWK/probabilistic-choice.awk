#!/usr/bin/awk -f

BEGIN {
    ITERATIONS = 1000000
    delete symbMap
    delete probMap
    delete counts
    initData();

    for (i = 0; i < ITERATIONS; i++) {
        distribute(rand())
    }
    showDistributions()

    exit
}

function distribute(rnd,    cnt, symNum, sym, symPrb) {
    cnt = length(symbMap)
    for (symNum = 1; symNum <= cnt; symNum++) {
        sym = symbMap[symNum];
        symPrb = probMap[sym];
        rnd -= symPrb;
        if (rnd <= 0) {
            counts[sym]++
            return;
        }
    }
}

function showDistributions(    s, sym, prb, actSum, expSum, totItr) {
    actSum = 0.0
    expSum = 0.0
    totItr = 0
    printf "%-7s  %-7s  %-5s  %-5s\n", "symb", "num.", "act.", "expt."
    print  "-------  -------  -----  -----"
    for (s = 1; s <= length(symbMap); s++) {
        sym = symbMap[s]
        prb = counts[sym]/ITERATIONS
        actSum += prb
        expSum += probMap[sym]
        totItr += counts[sym]
        printf "%-7s  %7d  %1.3f  %1.3f\n", sym, counts[sym], prb, probMap[sym]
    }
    print  "-------  -------  -----  -----"
    printf "Totals:  %7d  %1.3f  %1.3f\n", totItr, actSum, expSum
}

function initData(    sym) {
    srand()

    probMap["aleph"]  = 1.0 / 5.0
    probMap["beth"]   = 1.0 / 6.0
    probMap["gimel"]  = 1.0 / 7.0
    probMap["daleth"] = 1.0 / 8.0
    probMap["he"]     = 1.0 / 9.0
    probMap["waw"]    = 1.0 / 10.0
    probMap["zyin"]   = 1.0 / 11.0
    probMap["heth"]   = 1759.0 / 27720.0

    symbMap[1] = "aleph"
    symbMap[2] = "beth"
    symbMap[3] = "gimel"
    symbMap[4] = "daleth"
    symbMap[5] = "he"
    symbMap[6] = "waw"
    symbMap[7] = "zyin"
    symbMap[8] = "heth"

    for (sym in probMap)
        counts[sym] = 0;
}
