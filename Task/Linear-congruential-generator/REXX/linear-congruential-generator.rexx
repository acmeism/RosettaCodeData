-- 13 Jun 2026
include Setting

say 'LINEAR CONGRUENTIAL GENERATOR'
say version
say
numeric digits 20
Save. = 0
say '-------------------'
say ' n        BSD    MS'
say '-------------------'
do i = 1 to 10
   say Right(i,2) Right(MSD(),10) Right(MS(),5)
end
say '-------------------'
exit

MSD:
procedure expose Save.
Save.msd = (1103515245*Save.msd+12345)//(2**31)
return Save.msd

MS:
procedure expose Save.
Save.ms = (214013*Save.ms+2531011)//(2**31)
return Save.ms%(2**16)

include Math
