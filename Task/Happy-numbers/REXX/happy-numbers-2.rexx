-- 7 Aug 2025
include Settings

say 'HAPPY NUMBERS'
say version
say
say 'Process first 8...'
call HappyS -8
call ShowFirst8
call Timer 'r'
say 'Process first 10 million...'
call Happys -1e7
call Timer 'r'
call ShowNth 1e1
call ShowNth 1e2
call ShowNth 1e3
call ShowNth 1e4
call ShowNth 1e5
call ShowNth 1e6
call ShowNth 1e7
call Timer 'r'
exit

ShowFirst8:
procedure expose Happ.
say 'First 8 Happy numbers are'
do i = 1 to 8
   call Charout ,Right(Happ.i,3)
   if i//20 = 0 then
      say
end
say
return

ShowNth:
procedure expose Happ.
arg xx
xx = xx/1
say xx'th Happy number is' Happ.xx
return

include Math
