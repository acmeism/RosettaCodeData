-- 22 Mar 2025
include Settings

say 'MAGNANIMOUS NUMBERS'
say version
say
call Magnanimouss 1e6
call Range 1 45
call Range 241 250
call Range 391 400
call Range 430 999
say Time('e')/1 'seconds'
exit

Range:
procedure expose magn.
arg xx yy
if yy = '' then
   yy = xx
say 'The Magnanimous numbers from no' xx 'up to' yy 'are'
do i = xx to Min(yy,magn.0)
   call Charout ,magn.i' '
end
say; say
return

include Sequences
include Numbers
include Functions
include Abend
