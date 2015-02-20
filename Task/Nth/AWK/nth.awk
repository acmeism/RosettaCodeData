# syntax: GAWK -f NTH.AWK
BEGIN {
    prn(0,25)
    prn(250,265)
    prn(1000,1025)
    exit(0)
}
function prn(start,stop,  i) {
    printf("%d-%d: ",start,stop)
    for (i=start; i<=stop; i++) {
      printf("%d%s ",i,nth(i))
    }
    printf("\n")
}
function nth(yearday,  nthday) {
    if (yearday ~ /1[1-3]$/) {         # 11th,12th,13th
      nthday = "th"
    }
    else if (yearday ~ /1$/) {         # 1st,21st,31st,etc.
      nthday = "st"
    }
    else if (yearday ~ /2$/) {         # 2nd,22nd,32nd,etc.
      nthday = "nd"
    }
    else if (yearday ~ /3$/) {         # 3rd,23rd,33rd,etc.
      nthday = "rd"
    }
    else if (yearday ~ /[0456789]$/) { # 4th-10th,20th,24th-30th,etc.
      nthday = "th"
    }
    return(nthday)
}
