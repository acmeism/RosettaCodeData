-- 8 May 2025
include Settings
parse arg xx','yy','zz
if xx = '' then
   xx = 'Random'
if yy = '' then
   yy = 1e6
if zz = '' then
   zz = 0.3

say 'VERIFY DISTRIBUTION UNIFORMITY / NAIVE'
say version
say
call Parameters xx,yy,zz
call Get xx,yy
call Check yy,zz
call Timer
exit

Parameters:
procedure
parse arg xx,yy,zz
say 'Generator :' xx
say 'Count     :' yy
say 'Tolerance :' zz'%'
say
return

Get:
procedure expose work. coun. glob.
parse arg xx,yy
say 'Get uniform distributed integers 1 thru 7...'
work. = 0; coun. = 0
do n = 1 to yy
   interpret 'r =' xx'(1,7)'
   work.n = r; coun.r = coun.r+1
end
work.0 = yy
say 'Done'
say
return

Check:
procedure expose coun.
arg xx,yy
say 'And Verify them...'
a = xx%7
say 'Per bin about' a 'expected'
say '-------------------------------'
say 'n   count  skew    skew% test? '
say '-------------------------------'
v = 1
do n = 1 to 7
   b = coun.n-a; c = Round(100*b/a,3)
   if Abs(c) > yy then do
      d = 'Failed'; v = 0
   end
   else
      d = 'Passed'
   say n Right(coun.n,7) Right(b,5) Right(c'%',8) d
end
say '-------------------------------'
if v then
   e = 'did'
else
   e = 'did not'
say 'The set' e 'pass the test'
say
return

include Functions
include Constants
include Helper
include Abend
