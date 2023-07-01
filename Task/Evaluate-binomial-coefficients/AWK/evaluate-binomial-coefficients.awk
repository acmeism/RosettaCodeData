# syntax: GAWK -f EVALUATE_BINOMIAL_COEFFICIENTS.AWK
BEGIN {
    main(5,3)
    main(100,2)
    main(33,17)
    exit(0)
}
function main(n,k,  i,r) {
    r = 1
    for (i=1; i<k+1; i++) {
      r *= (n - i + 1) / i
    }
    printf("%d %d = %d\n",n,k,r)
}
