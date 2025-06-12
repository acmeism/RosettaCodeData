-- 8 May 2025
include Settings

say 'EUCLID-MULLIN SEQUENCE'
say version
say
numeric digits 100
call Euclids 16
call Task 16
say Format(Time('e'),,3) 'seconds'
exit

Task:
arg xx
say 'The first' xx 'Euclid-Mullin numbers are:'
do i = 1 to xx
   call Charout ,eucl.i' '
end
say
return

include Functions
include Sequences
include Numbers
include Abend
