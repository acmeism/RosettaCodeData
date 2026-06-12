# syntax: GAWK -f COUNT_THE_OCCURRENCE_OF_EACH_DIGIT_IN_E.AWK
# converted from Wren
BEGIN {
    main(2000)
    main(3000)
    exit(0)
}
function main(limit,  a,c,col,dc,i,v) {
    dc[2] = 1 # to count the non-fractional digit
    for (i=0; i<limit; i++) {
      v[i] = 1
    }
    for (col=0; col<2*limit; col++) {
      a = limit + 1
      c = 0
      for (i=0; i<=limit-1; i++) {
        c += v[i] * 10
        v[i] = int(c % a)
        c = int(c / a)
        a--
      }
      dc[c]++ # digit count
    }
    for (i=0; i<=9; i++) {
      printf("%d=%d ",i,dc[i])
    }
    printf("limit=%d\n",limit)
}
