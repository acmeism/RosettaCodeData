-- 27 Sep 2025
include Setting

say 'BASE 16 NUMBERS NEEDING A TO F'
say version
say
n=0
do i=1 to 500
   if Verify('ABCDEF',D2X(i),'m')>0 then do
      n+=1
      call CharOut ,Right(i,4)
      if n//20=0 then
         say
   end
end
say
say n 'found'
exit

include Abend
