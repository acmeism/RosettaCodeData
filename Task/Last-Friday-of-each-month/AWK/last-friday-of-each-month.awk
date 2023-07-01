# syntax: GAWK -f LAST_FRIDAY_OF_EACH_MONTH.AWK year
# converted from Fortran
BEGIN {
    split("31,28,31,30,31,30,31,31,30,31,30,31",daynum_array,",") # days per month in non leap year
    year = ARGV[1]
    if (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) {
      daynum_array[2] = 29
    }
    y = year - 1
    k = 44 + y + int(y/4) + int(6*(y/100)) + int(y/400)
    for (m=1; m<=12; m++) {
      k += daynum_array[m]
      d = daynum_array[m] - (k%7)
      printf("%04d-%02d-%02d\n",year,m,d)
    }
    exit(0)
}
