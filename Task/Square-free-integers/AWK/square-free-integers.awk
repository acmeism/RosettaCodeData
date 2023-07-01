# syntax: GAWK -f SQUARE-FREE_INTEGERS.AWK
# converted from LUA
BEGIN {
    main(1,145,1)
    main(1000000000000,1000000000145,1)
    main(1,100,0)
    main(1,1000,0)
    main(1,10000,0)
    main(1,100000,0)
    main(1,1000000,0)
    exit(0)
}
function main(lo,hi,show_values,  count,i,leng) {
    printf("%d-%d: ",lo,hi)
    leng = length(lo) + length(hi) + 3
    for (i=lo; i<=hi; i++) {
      if (square_free(i)) {
        count++
        if (show_values) {
          if (leng > 110) {
            printf("\n")
            leng = 0
          }
          printf("%d ",i)
          leng += length(i) + 1
        }
      }
    }
    printf("count=%d\n\n",count)
}
function square_free(n,  root) {
    for (root=2; root<=sqrt(n); root++) {
      if (n % (root * root) == 0) {
        return(0)
      }
    }
    return(1)
}
