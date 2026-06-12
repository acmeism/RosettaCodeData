func wkday year month day .
   adj = (14 - month) div 12
   mm = month + 12 * adj - 2
   yy = year - adj
   r = day + (13 * mm - 1) div 5 + yy + yy div 4 - yy div 100 + yy div 400
   return r mod 7 + 1
.
wkdays$[] = [ "Sunday" "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" ]
dates$[] = [ "2021-12-21" "2022-01-01" ]
for d$ in dates$[]
   write d$ & " is on "
   a[] = number strsplit d$ "-"
   print wkdays$[wkday a[1] a[2] a[3]]
.
