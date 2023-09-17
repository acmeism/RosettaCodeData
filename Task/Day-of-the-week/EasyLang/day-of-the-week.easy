func dayOfTheWeek year month day .
   # Based on Conway's doomsday algorithm
   # 1. Calculate the doomsday for the century
   century = floor (year / 100)
   if century mod 4 = 0
      centuryDoomsday = 2
   elif century mod 4 = 1
      centuryDoomsday = 0
   elif century mod 4 = 2
      centuryDoomsday = 5
   elif century mod 4 = 3
      centuryDoomsday = 3
   .
   # 2. Find the doomsday of the year
   mainYear = year mod 100
   yearDoomsday = (floor (mainYear / 12) + mainYear mod 12 + floor (mainYear mod 12 / 4) + centuryDoomsday) mod 7
   # 3. Check if the year is leap
   if mainYear = 0
      if century mod 4 = 0
         leap = 1
      else
         leap = 0
      .
   else
      if mainYear mod 4 = 0
         leap = 1
      else
         leap = 0
      .
   .
   # 4. Calculate the DOTW of January 1
   if leap = 1
      januaryOne = (yearDoomsday + 4) mod 7
   else
      januaryOne = (yearDoomsday + 5) mod 7
   .
   # 5. Determine the nth day of the year
   if month = 1
      NthDay = 0
   elif month = 2
      NthDay = 31
   elif month = 3
      NthDay = 59 + leap
   elif month = 4
      NthDay = 90 + leap
   elif month = 5
      NthDay = 120 + leap
   elif month = 6
      NthDay = 151 + leap
   elif month = 7
      NthDay = 181 + leap
   elif month = 8
      NthDay = 212 + leap
   elif month = 9
      NthDay = 243 + leap
   elif month = 10
      NthDay = 273 + leap
   elif month = 11
      NthDay = 304 + leap
   elif month = 12
      NthDay = 334 + leap
   .
   NthDay += day
   # 6. Finally, calculate the day of the week
   return (januaryOne + NthDay - 1) mod 7
.
for i = 2008 to 2121
   if dayOfTheWeek i 12 25 = 0
      print "Christmas in " & i & " is on Sunday"
   .
.
