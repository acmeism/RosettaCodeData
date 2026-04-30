-- 11 Sep 2025
include Setting

say 'OPTIONAL PARAMETERS'
say version
say
call Stem
call Sort1
call Sort1 'n',,'yes'
call Sort1 ,12,''
call Sort1 'n',12,'yes'
say
call Sort2
call Sort2 'order=n rev=yes'
call Sort2 'col=12'
call Sort2 'order=n col=12 rev=yes'
exit

Stem:
-- Populate an array
procedure expose stem.
-- Your code...
return

Sort1:
-- Comma separated positional parameters
procedure expose stem.
arg order,col,rev
call charout ,'Sort1:' 'Order='order 'Column='col 'Reverse='rev
if order = '' then
   order='L'
if col = '' then
   col=1
rev=(Left(rev,1)='Y')
say '  ---> ' 'Order='order 'Column='col 'Reverse='rev
-- Your sort...
return

Sort2:
-- Space separated named parameters
procedure expose stem.
arg xx
call charout ,'Sort2:' 'Parms='xx
order='L'; col=1; rev=0
do n = 1 to Words(xx)
   w=Word(xx,n); parse var w nam '=' val
   select
      when nam = 'ORDER' then
         order=val
      when nam = 'COL' then
         col=val
      when nam = 'REV' then
         rev=(Left(val,1) = 'Y')
      otherwise
         nop
   end
end
say '  ---> ' 'Order='order 'Column='col 'Reverse='rev
-- Your sort...
return

include Math
