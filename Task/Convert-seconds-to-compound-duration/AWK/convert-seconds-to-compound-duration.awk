# syntax: GAWK -f CONVERT_SECONDS_TO_COMPOUND_DURATION.AWK
BEGIN {
    n = split("7259 86400 6000000 0 1 60 3600 604799 604800 694861",arr," ")
    for (i=1; i<=n; i++) {
      printf("%9s %s\n",arr[i],howlong(arr[i]))
    }
    exit(0)
}
function howlong(seconds,  n_day,n_hour,n_min,n_sec,n_week,str,x) {
    if (seconds >= (x = 60*60*24*7)) {
      n_week = int(seconds / x)
      seconds = seconds % x
    }
    if (seconds >= (x = 60*60*24)) {
      n_day = int(seconds / x)
      seconds = seconds % x
    }
    if (seconds >= (x = 60*60)) {
      n_hour = int(seconds / x)
      seconds = seconds % x
    }
    if (seconds >= (x = 60)) {
      n_min = int(seconds / x)
      seconds = seconds % x
    }
    n_sec = int(seconds)
    str = (n_week > 0) ? (str n_week " wk, ") : str
    str = (n_day > 0) ? (str n_day " d, ") : str
    str = (n_hour > 0) ? (str n_hour " hr, ") : str
    str = (n_min > 0) ? (str n_min " min, ") : str
    str = (n_sec > 0) ? (str n_sec " sec") : str
    sub(/, $/,"",str)
    return(str)
}
