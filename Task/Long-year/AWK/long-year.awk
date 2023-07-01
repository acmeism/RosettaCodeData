# syntax: GAWK -f LONG_YEAR.AWK
BEGIN {
    for (cc=19; cc<=21; cc++) {
      printf("%2d00-%2d99: ",cc,cc)
      for (yy=0; yy<=99; yy++) {
        ccyy = sprintf("%02d%02d",cc,yy)
        if (is_long_year(ccyy)) {
          printf("%4d ",ccyy)
        }
      }
      printf("\n")
    }
#
    printf("\n%4d-%4d: ",by=1970,ey=2037)
    for (y=by; y<=ey; y++) {
      if (strftime("%V",mktime(sprintf("%d 12 28 0 0 0",y))) == 53) {
        printf("%4d ",y)
      }
    }
    printf("\n")
    exit(0)
}
function is_long_year(year,  i) {
    for (i=0; i<=1; i++) {
      year -= i
      if ((year + int(year/4) - int(year/100) + int(year/400)) % 7 == 4-i) {
        return(1)
      }
    }
    return(0)
}
