# Project : Date manipulation
# Date    : 2018/02/14
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

load "stdlib.ring"
dateorigin = "March 7 2009 7:30pm EST"
monthname = "January February March April May June July August September October November December"
for i = 1 to 12
     if dateorigin[1] = monthname[i]
        monthnum = i
     ok	
next
thedate = str2list(substr(dateorigin, " ", nl))
t = thedate[4]	
t1 = substr(t,"pm", "")
t2 = substr(t1,":",".")
t3 = number(t2)
if right(t,2) = "pm"
   t3 = t3+ 12
ok
ap = "pm"
d = "07/03/2009"
if t3 + 12 > 24
  d = adddays("07/03/2009",1)
  ap = "am"
ok
see "Original - " + dateorigin + nl
see "Manipulated - " + d + " " + t1 + ap + nl
