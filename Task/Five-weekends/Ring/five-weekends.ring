sum = 0
month = list(12)
mo = [4,0,0,3,5,1,3,6,2,4,0,2]
mon = [31,28,31,30,31,30,31,31,30,31,30,31]
mont = ["January","February","March","April","May","June",
        "July","August","September","October","November","December"]
for year = 1900 to 2100
    if year < 2100 leap = year - 1900 else leap = year - 1904 ok
    m = ((year-1900)%7) + floor(leap/4) % 7
    oldsum = sum
    for n = 1 to 12
        month[n] = (mo[n] + m) % 7
        x = (month[n] + 1) % 7
        if x = 2 and mon[n] = 31 sum += 1 see "" + year + "-" + mont[n] + nl ok
    next
    if sum = oldsum see "" + year + "-" + "(none)" + nl ok
next
see "Total : " + sum + nl
