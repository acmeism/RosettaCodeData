# DDATE.AWK - Gregorian to Discordian date contributed by Dan Nielsen
# syntax: GAWK -f DDATE.AWK [YYYYMMDD | YYYY-MM-DD | MM-DD-YYYY | DDMMMYYYY | YYYY] ...
# examples:
#   GAWK -f DDATE.AWK                    today
#   GAWK -f DDATE.AWK 20110722           one date
#   GAWK -f DDATE.AWK 20110722 20120229  two dates
#   GAWK -f DDATE.AWK 2012               yearly calendar
BEGIN {
    split("Chaos,Discord,Confusion,Bureaucracy,The Aftermath",season_arr,",")
    split("Sweetmorn,Boomtime,Pungenday,Prickle-Prickle,Setting Orange",weekday_arr,",")
    split("Mungday,Mojoday,Syaday,Zaraday,Maladay",apostle_holyday_arr,",")
    split("Chaoflux,Discoflux,Confuflux,Bureflux,Afflux",season_holyday_arr,",")
    split("31,28,31,30,31,30,31,31,30,31,30,31",days_in_month,",") # days per month in non leap year
    split("0   31  59  90  120 151 181 212 243 273 304 334",rdt," ") # relative day table
    mmm = "JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC"
#          1   2   3   4   5   6   7   8   9   10  11  12
    if (ARGV[1] == "") { # use current date
      ARGV[ARGC++] = strftime("%Y%m%d") # GAWK only
    # ARGV[ARGC++] = dos_date() # any AWK
    # timetab(arr); ARGV[ARGC++] = sprintf("%04d%02d%02d",arr["YEAR"],arr["MONTH"],arr["DAY"]) # TAWK only
    }
    for (argno=1; argno<=ARGC-1; argno++) { # validate command line arguments
      print("")
      x = toupper(ARGV[argno])
      if (x ~ /^[0-9][0-9][0-9][0-9][01][0-9][0-3][0-9]$/) { # YYYYMMDD
        main(x)
      }
      else if (x ~ /^[0-9][0-9][0-9][0-9]-[01][0-9]-[0-3][0-9]$/) { # YYYY-MM-DD
        gsub(/-/,"",x)
        main(x)
      }
      else if (x ~ /^[01][0-9]-[0-3][0-9]-[0-9][0-9][0-9][0-9]$/) { # MM-DD-YYYY
        main(substr(x,7,4) substr(x,1,2) substr(x,4,2))
      }
      else if (x ~ /^[0-3][0-9](JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)[0-9][0-9][0-9][0-9]$/) { # DDMMMYYYY
        main(sprintf("%04d%02d%02d",substr(x,6,4),int((match(mmm,substr(x,3,3))/4)+1),substr(x,1,2)))
      }
      else if (x ~ /^[0-9][0-9][0-9][0-9]$/) { # YYYY
        yearly_calendar(x)
      }
      else {
        error("begin")
      }
    }
    if (errors == 0) { exit(0) } else { exit(1) }
}
function main(x,  d,dyear,m,season_day,season_nbr,text,weekday_nbr,y,year_day) {
    y = substr(x,1,4) + 0
    m = substr(x,5,2) + 0
    d = substr(x,7,2) + 0
    days_in_month[2] = (leap_year(y) == 1) ? 29 : 28
    if (m < 1 || m > 12 || d < 1 || d > days_in_month[m]+0) {
      error("main")
      return
    }
    year_day = rdt[m] + d
    dyear = y + 1166 # Discordian year
    season_nbr = int((year_day - 1 ) / 73) + 1
    season_day = ((year_day - 1) % 73) + 1
    weekday_nbr = ((year_day - 1 ) % 5) + 1
    if (season_day == 5) {
      text = ", " apostle_holyday_arr[season_nbr]
    }
    else if (season_day == 50) {
      text = ", " season_holyday_arr[season_nbr]
    }
    if (leap_year(y) && m == 2 && d == 29) {
      printf("%04d-%02d-%02d is St. Tib's day, Year of Our Lady of Discord %s\n",y,m,d,dyear)
    }
    else {
      printf("%04d-%02d-%02d is %s, %s %s, Year of Our Lady of Discord %s%s\n",
      y,m,d,weekday_arr[weekday_nbr],season_arr[season_nbr],season_day,dyear,text)
    }
}
function leap_year(y) { # leap year: 0=no, 1=yes
    return (y % 400 == 0 || (y % 4 == 0 && y % 100)) ? 1 : 0
}
function yearly_calendar(y,  d,m) {
    days_in_month[2] = (leap_year(y) == 1) ? 29 : 28
    for (m=1; m<=12; m++) {
      for (d=1; d<=days_in_month[m]; d++) {
        main(sprintf("%04d%02d%02d",y,m,d))
      }
    }
}
function dos_date(  cmd,x) { # under Microsoft Windows XP
    cmd = "DATE <NUL"
    cmd | getline x # The current date is: MM/DD/YYYY
    close(cmd) # close pipe
    return sprintf("%04d%02d%02d",substr(x,28,4),substr(x,22,2),substr(x,25,2))
}
function error(x) {
    printf("error: argument %d is invalid, %s, in %s\n",argno,ARGV[argno],x)
    errors++
}
