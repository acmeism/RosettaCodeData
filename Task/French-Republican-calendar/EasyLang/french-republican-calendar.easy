func repLeap y .
   return if (y + 1) mod 4 = 0 and ((y + 1) mod 100 <> 0 or (y + 1) mod 400 = 0)
.
func greLeap y .
   return if y mod 4 = 0 and y mod 100 <> 0 or y mod 400 = 0
.
gregmd[] = [ 31 28 31 30 31 30 31 31 30 31 30 31 ]
greg$[] = [ "January" "February" "March" "April" "May" "June" "July" "August" "September", "October" "November" "December" ]
repu$[] = [ "Vendémiaire" "Brumaire" "Frimaire" "Nivôse" "Pluviôse" "Ventôse" "Germinal" "Floréal" "Prairial" "Messidor" "Thermidor" "Fructidor" "Sansculottide" ]
sanscu$[] = [ "Fête de la vertu" "Fête du génie" "Fête du travail" "Fête de l'opinion" "Fête des récompenses" "Fête de la Révolution" ]
proc split s$ &d &m &y .
   if substr s$ 1 4 = "Fête"
      m = 13
      for d to len sanscu$[]
         sc$ = sanscu$[d]
         if substr s$ 1 len sc$ = sc$
            y = number substr s$ (len sc$ + 1) 99
            break 1
         .
      .
   else
      h = strpos s$ " "
      d = number substr s$ 1 h
      my$ = substr s$ (h + 1) 99
      h = strpos my$ " "
      m$ = substr my$ 1 (h - 1)
      y = number substr my$ (h + 1) 99
      months$[] = greg$[]
      if y < 1792 : months$[] = repu$[]
      for m to 12 : if months$[m] = m$ : break 1
   .
.
func greToDay d m y .
   if m < 3
      y -= 1
      m += 12
   .
   return y * 36525 div 100 - y div 100 + y div 400 + 306 * (m + 1) div 10 + d - 654842
.
func repToDay d m y .
   if m = 13
      m -= 1
      d += 30
   .
   d -= repLeap y
   return 365 * y + (y + 1) div 4 - (y + 1) div 100 + (y + 1) div 400 + 30 * m + d - 395
.
proc dayToGre day &d &m &y .
   y = day * 100 div 36525
   d = day - y * 36525 div 100 + 21
   y += 1792
   d += y div 100 - y div 400 - 13
   m = 9
   while d > gregmd[m]
      d -= gregmd[m]
      m += 1
      if m = 13
         m = 1
         y += 1
         gregmd[2] = 28 + greLeap y
      .
   .
.
proc dayToRep day &d &m &y .
   y = (day - 1) * 100 div 36525
   if repLeap y = 1 : y -= 1
   y += 1
   d = day - y * 36525 div 100 + 365 + y div 100 - y div 400
   m = 1
   sanscul = 5 + repLeap y
   while d > 30
      d -= 30
      m += 1
      if m = 13
         if d > sanscul
            d -= sanscul
            m = 1
            y += 1
            sanscul = 5 + repLeap y
         .
      .
   .
.
test$[] = [ "1 Vendémiaire 1" "1 Prairial 3" "27 Messidor 7" "Fête de la Révolution 11" "10 Nivôse 14" "22 September 1792" "20 May 1795" "15 July 1799" "23 September 1803" "31 December 1805" ]
for s$ in test$[]
   write s$ & " => "
   split s$ day, month, year
   if year < 1792
      dayToGre (repToDay day month year) day month year
      print day & " " & greg$[month] & " " & year
   else
      dayToRep (greToDay day month year) day month year
      if month = 13
         print sanscu$[day] & " " & year
      else
         print day & " " & repu$[month] & " " & year
      .
   .
.
