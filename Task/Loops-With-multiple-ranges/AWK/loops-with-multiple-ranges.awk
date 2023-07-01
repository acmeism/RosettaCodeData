# syntax: GAWK -f LOOPS_WITH_MULTIPLE_RANGES.AWK
BEGIN {
    prod = 1
    sum = 0
    x = 5
    y = -5
    z = -2
    one = 1
    three = 3
    seven = 7
    for (j=-three; j<=(3^3); j+=three) { main(j) }
    for (j=-seven; j<=seven; j+=x) { main(j) }
    for (j=555; j<=550-y; j++) { main(j) }
    for (j=22; j>=-28; j+=-three) { main(j) }
    for (j=1927; j<=1939; j++) { main(j) }
    for (j=x; j>=y; j+=z) { main(j) }
    for (j=(11^x); j<=(11^x)+1; j++) { main(j) }
    printf("sum = %d\n",sum)
    printf("prod = %d\n",prod)
    exit(0)
}
function main(x) {
    sum += abs(x)
    if (abs(prod) < (2^27) && x != 0) {
      prod *= x
    }
}
function abs(x) { if (x >= 0) { return x } else { return -x } }
