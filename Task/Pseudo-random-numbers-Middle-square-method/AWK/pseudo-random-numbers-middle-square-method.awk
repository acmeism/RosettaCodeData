# syntax: GAWK -f PSEUDO-RANDOM_NUMBERS_MIDDLE-SQUARE_METHOD.AWK
BEGIN {
    seed = 675248
    srand(seed)
    for (i=1; i<=5; i++) {
      printf("%2d: %s\n",i,main())
    }
    exit(0)
}
function main(  s) {
    s = seed ^ 2
    while (length(s) < 12) {
      s = "0" s
    }
    seed = substr(s,4,6)
    return(seed)
}
