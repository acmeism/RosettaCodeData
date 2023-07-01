#!/usr/bin/awk -f

BEGIN {
    COINSEP = ", "
    coins = 1 COINSEP 5 COINSEP 10 COINSEP 25
    print cc(100, coins)
    exit
}

function cc(amt, coins) {
    if (length(coins) == 0) return 0
    if (amt < 0) return 0
    if (amt == 0) return 1
    return cc(amt, tail(coins)) + cc(amt - head(coins), coins)
}

function tail(coins,    koins, s, c) {
    split(coins, koins, COINSEP)
    s = ""
    for (c = 2; c <= length(koins); c++) s = s (s == "" ? "" : COINSEP) koins[c]
    return s;
}

function head(coins,    koins) {
    split(coins, koins, COINSEP)
    return koins[1]
}
