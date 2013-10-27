Works with Gnu awk version 3.1.5 and with BusyBox v1.20.0.git awk
To change the output width, change the value assigned to variable pagewide

#!/bin/gawk -f
BEGIN{
  wkdays = "Su Mo Tu We Th Fr Sa"
  pagewide = 80
  blank=" "
  for (i=1; i<pagewide; i++) blank = blank " "
  #  month name accessed as substr(month,num*10,10)
  #      where num is number of month, 1-12
  month= "           January  February    March     April  "
  month=    month "   May      June       July     August  "
  month=    month " September October   November  December "
  #  table of days per month accessed as substr(days,2*month,2)
  days =" 312831303130313130313031"
  line1 = ""
  line2 = ""
  line3 = ""
  line4 = ""
  line5 = ""
  line6 = ""
  line7 = ""
  line8 = ""
# print " year: " year " starts on: " dow(year)
  }
function center(text,   half) {
  half = (pagewide - length(text))/2
  return substr(blank,1,half) text substr(blank,1,half)
  }
function min(a,b) {
  if (a < b) return a
  else return b
  }
function makewk (fst,lst,day,  i,wstring ){
  wstring=""
  for (i=1;i<day;i++) wstring=wstring "   "
  for (i=fst;i<=lst;i++) wstring=wstring sprintf("%2d ",i)
  return substr(wstring "                     ",1,20)
  }
function dow (year, y){
  y=year
  y= (y*365+int(y/4) - int(y/100) + int(y/400) +1) %7
# leap year adjustment
  leap = 0
  if (year % 4 == 0)   leap = 1
  if (year % 100 == 0) leap = 0
  if (year % 400 == 0) leap = 1
  y = y - leap
  if (y==-1) y=6
  if (y==0) y=7
  return (y)
  }
function prmonth (nmonth, newdow,monsize  ){
  line1 = line1  "     " (substr(month,10*nmonth,10)) "       "
  line2 = line2  (wkdays) "  "
  line3 = line3  (makewk(1,8-newdow,newdow)) "  "
  line4 = line4  (makewk(9-newdow,15-newdow,1)) "  "
  line5 = line5  (makewk(16-newdow,22-newdow,1)) "  "
  line6 = line6  (makewk(23-newdow,29-newdow,1)) "  "
  line7 = line7  (makewk(30-newdow,min(monsize,36-newdow),1)) "  "
  line8 = line8  (makewk(37-newdow,monsize,1)) "  "
if (length(line3) + 22 > pagewide) {
  print center(line1)
  print center(line2)
  print center(line3)
  print center(line4)
  print center(line5)
  print center(line6)
  print center(line7)
  print center(line8)
  line1 = ""
  line2 = ""
  line3 = ""
  line4 = ""
  line5 = ""
  line6 = ""
  line7 = ""
  line8 = ""
  }
}
/q/{
  exit }
{
  monsize=substr(days,2*1,2)
  newdow=dow($1)
  print center("[ picture of Snoopy goes here ]")
  print center(sprintf("%d",$1)  )
  # January - December
  for (i=1; i<13; i++) {
  prmonth(i,newdow,monsize)
  newdow=(monsize+newdow) %7
  if (newdow == 0) newdow = 7
  monsize=substr(days,2+2*i,2)
  if (leap == 1 && monsize == 28) monsize = 29
  }
 }
