func weekday year month day .
   adj = (14 - month) div 12
   mm = month + 12 * adj - 2
   yy = year - adj
   r = day + (13 * mm - 1) div 5 + yy + yy div 4 - yy div 100 + yy div 400
   return r mod 7 + 1
.
wkdays$[] = [ "Sunday" "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" ]
dates$[] = [ "1800-01-06" "1875-03-29" "1915-12-07" "1970-12-23" "2043-05-14" "2077-02-12" "2101-04-02" ]
for d$ in dates$[]
   write d$ & " -> "
   a[] = number strsplit d$ "-"
   print wkdays$[weekday a[1] a[2] a[3]]
.
