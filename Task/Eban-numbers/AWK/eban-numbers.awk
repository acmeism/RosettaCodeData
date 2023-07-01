# syntax: GAWK -f EBAN_NUMBERS.AWK
# converted from FreeBASIC
BEGIN {
    main(2,1000,1)
    main(1000,4000,1)
    main(2,10000,0)
    main(2,100000,0)
    main(2,1000000,0)
    main(2,10000000,0)
    main(2,100000000,0)
    exit(0)
}
function main(start,stop,printable,  b,count,i,m,r,t) {
    printf("%d-%d:",start,stop)
    for (i=start; i<=stop; i+=2) {
      b = int(i / 1000000000)
      r = i % 1000000000
      m = int(r / 1000000)
      r = i % 1000000
      t = int(r / 1000)
      r = r % 1000
      if (m >= 30 && m <= 66) { m %= 10 }
      if (t >= 30 && t <= 66) { t %= 10 }
      if (r >= 30 && r <= 66) { r %= 10 }
      if (x(b) && x(m) && x(t) && x(r)) {
        count++
        if (printable) {
          printf(" %d",i)
        }
      }
    }
    printf(" (count=%d)\n",count)
}
function x(n) {
    return(n == 0 || n == 2 || n == 4 || n == 6)
}
