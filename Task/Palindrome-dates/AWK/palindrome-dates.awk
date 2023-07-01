# syntax: GAWK -f PALINDROME_DATES.AWK
BEGIN {
    show = 15
    year_b = 2020
    year_e = 9999
    split("31,28,31,30,31,30,31,31,30,31,30,31",daynum_array,",") # days per month in non leap year
    for (y=year_b; y<=year_e; y++) {
      daynum_array[2] = (y % 400 == 0 || (y % 4 == 0 && y % 100)) ? 29 : 28
      for (m=1; m<=12; m++) {
        for (d=1; d<=daynum_array[m]; d++) {
          ymd = sprintf("%04d%02d%02d",y,m,d)
          if (substr(ymd,1,1) == substr(ymd,8,1)) { # speed up
            if (ymd == reverse(ymd)) {
              arr[++n] = ymd
            }
          }
        }
      }
    }
    printf("%04d0101-%04d1231=%d years, %d palindromes, showing first and last %d\n",year_b,year_e,year_e-year_b+1,n,show)
    printf("YYYYMMDD YYYYMMDD\n")
    for (i=1; i<=show; i++) {
      printf("%s %s\n",arr[i],arr[n-show+i])
    }
    exit(0)
}
function reverse(str,  i,rts) {
    for (i=length(str); i>=1; i--) {
      rts = rts substr(str,i,1)
    }
    return(rts)
}
