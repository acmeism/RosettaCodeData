see "What year to calculate (yyyy) : "
give year
see "Last Sundays in " + year + " are on :" + nl
month = list(12)
mo = [4,0,0,3,5,1,3,6,2,4,0,2]
mon = [31,28,31,30,31,30,31,31,30,31,30,31]
if year < 2100 leap = year - 1900 else leap = year - 1904 ok
m = ((year-1900)%7) + floor(leap/4) % 7
for n = 1 to 12
    month[n] = (mo[n] + m) % 7
next
for n = 1 to 12
    for i = (mon[n] - 6) to mon[n]
        x = (month[n] + i) % 7
        if  n < 10 strn = "0" + string(n) else strn = string(n) ok
        if x = 4 see year + "-" + strn + "-" + string(i) + nl ok
    next
next
