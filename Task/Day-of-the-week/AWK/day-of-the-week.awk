# syntax: GAWK -f DAY_OF_THE_WEEK.AWK
# runtime does not support years > 2037 on my 32-bit Windows XP O/S
BEGIN {
    for (i=2008; i<=2121; i++) {
      x = strftime("%Y/%m/%d %a",mktime(sprintf("%d 12 25 0 0 0",i)))
      if (x ~ /Sun/) { print(x) }
    }
}
