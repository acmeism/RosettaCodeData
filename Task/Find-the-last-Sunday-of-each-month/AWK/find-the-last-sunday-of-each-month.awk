# syntax: GAWK -f FIND_THE_LAST_SUNDAY_OF_EACH_MONTH.AWK [year]
BEGIN {
    split("31,28,31,30,31,30,31,31,30,31,30,31",daynum_array,",") # days per month in non leap year
    year = (ARGV[1] == "") ? strftime("%Y") : ARGV[1]
    if (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) {
      daynum_array[2] = 29
    }
    for (m=1; m<=12; m++) {
      for (d=daynum_array[m]; d>=1; d--) {
        if (strftime("%a",mktime(sprintf("%d %d %d 0 0 0",year,m,d))) == "Sun") {
          printf("%04d-%02d-%02d\n",year,m,d)
          break
        }
      }
    }
    exit(0)
}
