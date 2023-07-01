'call it with year, number of months per row (1,2,3,4,6) and locale ("" for default)
docal 1969,6,""

function center (s,n) x=n-len(s):center=space(x\2+(x and 1))& s & space(x\2):end function
sub print(x) wscript.stdout.writeline x : end sub
function iif(a,b,c) :if a then iif=b else iif =c end if : end function

sub docal (yr,nmonth,sloc)
'yr     year to print
'nmonth number of monts side to side, allowed values :1,2,3,4,6
'sloc   locale to use . "" uses the default

dim ld(6)
dim d(6)
if nmonth=5 or nmonth>6 or nmonth<1 then wscript.stderr.writeline "Can't use width " & nmonth :exit sub

'set the locale (names of months and weekdays plus first day of week)
if sloc<>"" then Setlocale sloc

'make a row of short weekday names to put on top of the month days
'trim the names to 2 char and align them right
wday=""
for i=1 to 7
  wday=wday &" "&right(" "& left(weekdayname(i,true,vbUseSystemDayOfWeek),2),2)
next

'print header of the calendar
ncols=nmonth*21+(nmonth-1)*1
print center("[Snoopy]",ncols)
print center(yr,ncols)
print string(ncols,"=")

'row of months
for i=1 to 12\nmonth
  s="": s1="":esp=""

  for j=1 to nmonth
    'build header of the month row
    s=s & esp & center(monthname(m+j),21)
    s1=s1 & esp & wday

    'get negative offset of first day of week to the weekday of day 1 of each month
    d(j)= -weekday(dateserial(yr,m+j,1),vbUseSystemDayOfWeek)+2
    'get last day of each month from Windows
    ld(j)=day(dateserial(yr,m+j+1,0))
    esp=" "
  next

  'print the row of months header (name of month and weekday names)
  print s:  print s1

  'weekday rows. makes 5 or 6 rows according to the month requiring most
  while(d(1)<ld(1)) or (d(2)<ld(2)) or (d(3)<ld(3)) or (d(4)<ld(4))or (d(5)<ld(5)) or (d(6)<ld(6))
    s=""
    for j=1 to nmonth
      'fill present week row
      for k=1 to 7
        'add a day number only if inside the range of days of this montg
        s=s& right(space(3)&iif(d(j)<1 or d(j)>ld(j),"",d(j)),3)
        d(j)=d(j)+1
      next
      s=s&" "
    next
    'print a complete row of days
    print s
  wend
  'go for the next row of monts
  m=m+nmonth
  if i<>12\nmonth then print ""
next

'print footer
print string(ncols,"=")
end sub
