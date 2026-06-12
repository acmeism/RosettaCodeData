global npos .
func val s$ .
   v = number substr s$ npos 6
   if substr s$ (npos + 5) 3 = "BCE" : v = -v
   return v
.
proc sort &d$[] .
   for i = 1 to len d$[] - 1 : for j = i + 1 to len d$[]
      if val d$[j] < val d$[i] : swap d$[j] d$[i]
   .
.
s$ = input
npos = len s$ - 7
if substr s$ npos 1 = " " : npos += 1
while s$ <> ""
   s$[] &= s$
   s$ = input
.
sort s$[]
for s$ in s$[] : print s$
#
input_data
Pi                250  BCE
Magic Squares     2200 BCE
Kwarizmi          830  CE
Dice              3000 BCE
Liber Abaci       1202 CE
Euclid's Elements 300  BCE
Euler's Number    1727 CE
The Abacus        1200 CE
