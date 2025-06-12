-- 22 Mar 2025
include Settings

say 'HAMMING NUMBERS'
say version
say
call Hammings 1000000
call ShowFirstN 20
call ShowNth 1691
call ShowNth 1000000
call Hammings 10000000
call ShowNth 10000000
say Time('e')/1 'seconds'
exit

ShowFirstN:
procedure expose hamm.
arg xx
xx = xx/1
say 'First' xx 'Hamming numbers are'
do i = 1 to xx
   call Charout ,Right(hamm.i,5)
   if i//10 = 0 then
      say
end
say
return

ShowNth:
procedure expose hamm.
arg xx
xx = xx/1
say xx'th Hamming number is'
say hamm.xx '('Length(hamm.xx) 'digits)'
say
return

include Sequences
include Functions
include Abend
