func leap year .
   return if year mod 4 = 0 and (year mod 100 <> 0 or year mod 400 = 0)
.
func weekday year month day .
   normdoom[] = [ 3 7 7 4 2 6 4 1 5 3 7 5 ]
   c = year div 100
   r = year mod 100
   s = r div 12
   t = r mod 12
   c_anchor = (5 * (c mod 4) + 2) mod 7
   doom = (s + t + (t div 4) + c_anchor) mod 7
   anchor = normdoom[month]
   if leap year = 1 and month <= 2
      anchor = (anchor + 1) mod1 7
   .
   return (doom + day - anchor + 7) mod 7 + 1
.
wkdays$[] = [ "Sunday" "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" ]
dates$[] = [ "1800-01-06" "1875-03-29" "1915-12-07" "1970-12-23" "2043-05-14" "2077-02-12" "2101-04-02" ]
for d$ in dates$[]
   write d$ & " -> "
   a[] = number strsplit d$ "-"
   print wkdays$[weekday a[1] a[2] a[3]]
.
