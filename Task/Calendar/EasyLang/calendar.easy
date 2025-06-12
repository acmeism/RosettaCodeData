year = 1969
# year = number substr timestr systime 1 4
#
wkdays$ = "Su Mo Tu We Th Fr Sa"
pagewide = 80
blank$ = ""
month$[] = [ "  January " " February " "   March  " "   April  " "   May    " "  June    " "   July   " "  August  " " September" " October  " " November " " December " ]
days[] = [ 31 28 31 30 31 30 31 31 30 31 30 31 ]
#
func$ center txt$ .
   h$ = substr blank$ 1 ((pagewide - len txt$) / 2)
   return h$ & txt$ & h$
.
func$ makewk fst lst day .
   for i to day - 1
      wstr$ &= "   "
   .
   for i = fst to lst
      i$ = i
      if i <= 9 : i$ = " " & i
      wstr$ &= i$ & " "
   .
   return substr wstr$ & blank$ 1 20
.
proc dow y &ndow &leap .
   leap = 0
   if y mod 4 = 0 : leap = 1
   if y mod 100 = 0 : leap = 0
   if y mod 400 = 0 : leap = 1
   ndow = y * 365 + y div 4 - y div 100 + y div 400 + 1
   ndow = (ndow - leap) mod1 7
.
len lin$[] 8
proc prmonth nmonth newdow monsize .
   lin$[1] &= "     " & month$[nmonth] & "       "
   lin$[2] &= wkdays$ & "  "
   lin$[3] &= makewk 1 (8 - newdow) newdow & "  "
   for i = 4 to 7
      lin$[i] &= makewk (9 + h - newdow) lower monsize (15 + h - newdow) 1 & "  "
      h += 7
   .
   lin$[8] &= makewk (37 - newdow) monsize 1 & "  "
   if len lin$[3] + 22 > pagewide
      for i to 8
         print center lin$[i]
         lin$[i] = ""
      .
   .
.
for i to pagewide : blank$ &= " "
dow year newdow leap
print center "[ picture of Snoopy goes here ]"
print center year
for i = 1 to 12
   monsize = days[i]
   if i = 2 and leap = 1 : monsize = 29
   prmonth i newdow monsize
   newdow = (monsize + newdow) mod1 7
.
