BEGIN {
    for (i = 1; i < 50; ++i){
        if (isHappy(i)) {
            print i;
        }
    }
    exit
}

function isHappy(n,    seen) {
    delete seen;
    while (1) {
        n = sumSqrDig(n)
        if (seen[n]) {
            return n == 1
        }
        seen[n] = 1
    }
}

function sumSqrDig(n,     d, tot) {
    while (n) {
        d = n % 10
        tot += d * d
        n = int(n/10)
    }
    return tot
}
