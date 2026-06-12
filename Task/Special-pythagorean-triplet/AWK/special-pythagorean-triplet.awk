# syntax: GAWK -f SPECIAL_PYTHAGOREAN_TRIPLET.AWK
# converted from FreeBASIC
BEGIN {
    main()
    exit(0)
}
function main(a,b,c,  limit) {
    limit = 1000
    for (a=1; a<=limit; a++) {
      for (b=a+1; b<=limit; b++) {
        for (c=b+1; c<=limit; c++) {
          if (a*a + b*b == c*c) {
            if (a+b+c == limit) {
              printf("%d+%d+%d=%d\n",a,b,c,a+b+c)
              printf("%d*%d*%d=%d\n",a,b,c,a*b*c)
              return
            }
          }
        }
      }
    }
}
