# syntax: GAWK -f DAYS_BETWEEN_DATES.AWK
BEGIN {
    regexp = "^....-..-..$" # YYYY-MM-DD
    main("1969-12-31","1970-01-01","builtin has bad POSIX start date")
    main("1970-01-01","2038-01-19","builtin has bad POSIX stop date")
    main("1970-01-01","2019-10-02","format OK")
    main("1970-01-01","2019/10/02","format NG")
    main("1995-11-21","1995-11-21","identical dates")
    main("2019-01-01","2019-01-02","positive date")
    main("2019-01-02","2019-01-01","negative date")
    main("2019-01-01","2019-03-01","non-leap year")
    main("2020-01-01","2020-03-01","leap year")
    exit(0)
}
function main(date1,date2,comment,  d1,d2,diff) {
    printf("\t%s\n",comment)
    d1 = days_builtin(date1)
    d2 = days_builtin(date2)
    diff = (d1 == "" || d2 == "") ? "error" : d2-d1
    printf("builtin %10s to %10s = %s\n",date1,date2,diff)
    d1 = days_generic(date1)
    d2 = days_generic(date2)
    diff = (d1 == "" || d2 == "") ? "error" : d2-d1
    printf("generic %10s to %10s = %s\n",date1,date2,diff)
}
function days_builtin(ymd) { # use gawk builtin
    if (ymd !~ regexp) { return("") }
    if (ymd < "1970-01-01" || ymd > "2038-01-18") { return("") } # outside POSIX range
    gsub(/-/," ",ymd)
    return(int(mktime(sprintf("%s 0 0 0",ymd)) / (60*60*24)))
}
function days_generic(ymd,  d,m,y,result) { # use Python formula
    if (ymd !~ regexp) { return("") }
    y = substr(ymd,1,4)
    m = substr(ymd,6,2)
    d = substr(ymd,9,2)
    m = (m + 9) % 12
    y = int(y - int(m/10))
    result = 365*y + int(y/4) - int(y/100) + int(y/400) + int((m*306+5)/10) + (d-1)
    return(result)
}
