-- 22 Mar 2025
include Settings

say 'LUDIC NUMBERS'
say version
say
call Ludics 2000
call Range 1 25
call Below 1000
call Ludics 22000
call Range 2000 2005
call Triplets 250
say Time('e')/1 'seconds'
exit

Range:
procedure expose ludi.
arg xx yy
if yy = '' then
   yy = xx
say 'The Ludic numbers from no' xx 'up to' yy 'are'
do i = xx to yy
   call Charout ,ludi.i' '
end
say; say
return

Below:
procedure expose ludi.
arg xx
do i = 1 until ludi.i >= xx
end
say 'There are' i-1 'Ludic numbers <=' xx
say
return

Triplets:
procedure expose ludi. work.
arg xx
say 'Found triplets below' xx
do i = 1 until l3 >= xx
   l1 = i; l2 = i+2; l3 = i+6
   if work.l1 & work.l2 & work.l3 then do
      call Charout ,'['l1 l2 l3'] '
   end
end
say; say
return

include Sequences
include Functions
include Abend
