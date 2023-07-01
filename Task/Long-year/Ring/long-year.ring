see "long years 2000-2099: "
for year = 2000 to 2100
    num1 = (year-1900)%7
    num2 = floor((year-1904)/4)
    num3 = (num1+num2+5)%7
    if num3 = 0 or (num1 = 6 and num3 = 1)
       see "" + year + " "
    ok
next
