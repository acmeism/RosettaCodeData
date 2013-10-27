# syntax: GAWK -f DATE_MANIPULATION.AWK
BEGIN {
    fmt = "%a %Y-%m-%d %H:%M:%S %Z" # DAY YYYY-MM-DD HH:MM:SS TZ
    split("March 7 2009 7:30pm EST",arr," ")
    M = (index("JanFebMarAprMayJunJulAugSepOctNovDec",substr(arr[1],1,3)) + 2) / 3
    D = arr[2]
    Y = arr[3]
    hhmm = arr[4]
    hh = substr(hhmm,1,index(hhmm,":")-1) + 0
    mm = substr(hhmm,index(hhmm,":")+1,2) + 0
    if (hh == 12 && hhmm ~ /am/) { hh = 0 }
    else if (hh < 12 && hhmm ~ /pm/) { hh += 12 }
    time = mktime(sprintf("%d %d %d %d %d %d",Y,M,D,hh,mm,0))
    printf("time:    %s\n",strftime(fmt,time))
    time += 12*60*60
    printf("+12 hrs: %s\n",strftime(fmt,time))
    exit(0)
}
