'arithmetic numbers
'run with CScript

function isarit_compo(i)
     cnt=0
     sum=0
     for j=1 to sqr(i)
       if (i mod j)=0 then
          k=i\j

         if k=j then
            cnt=cnt+1:sum=sum+j
         else
            cnt=cnt+2:sum=sum+j+k
         end if
       end if
     next
   avg= sum/cnt
   isarit_compo= array((fix(avg)=avg),-(cnt>2))
end function

function rpad(a,n) rpad=right(space(n)&a,n) :end function

dim s1
sub print(s)
  s1=s1& rpad(s,4)
  if len(s1)=40 then wscript.stdout.writeline s1:s1=""
end sub

'main program
cntr=0
cntcompo=0
i=1
wscript.stdout.writeline "the first 100 arithmetic numbers are:"
do
  a=isarit_compo(i)
  if a(0) then
    cntcompo=cntcompo+a(1)
    cntr=cntr+1
    if cntr<=100 then print i
    if cntr=1000 then wscript.stdout.writeline vbcrlf&"1000th   : "&rpad(i,6) & " nr composites " &rpad(cntcompo,6)
    if cntr=10000 then wscript.stdout.writeline vbcrlf& "10000th  : "&rpad(i,6) & " nr composites " &rpad(cntcompo,6)
    if cntr=100000 then wscript.stdout.writeline vbcrlf &"100000th : "&rpad(i,6) & " nr composites " &rpad(cntcompo,6):exit do
  end if
  i=i+1
loop
