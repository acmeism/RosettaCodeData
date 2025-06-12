-- 22 Mar 2025
include Settings

say 'CYCLOPS NUMBERS'
say version
say
numeric digits 10; cycl. = 0
call Cyclops 115e6
say cycl.0 'cyclops numbers generated < 115 million'; say
call CyclopsNumbers
call PrimeCyclops
call BlindCyclops
call PalindromicCyclops
say Format(Time('e'),,3) 'seconds'
exit

CyclopsNumbers:
procedure expose cycl.
say 'First 50 cyclop numbers:'
do i = 1 to cycl.0
   a = cycl.i
   if i <= 50 then do
      call Charout ,Right(a,8)
      if i//10 = 0 then
         say
   end
   if a > 1e7 then do
      say 'First such number > 1e7 is' a 'at index' i; say
      leave i
   end
end
return

PrimeCyclops:
procedure expose cycl.
say 'First 50 prime cyclop numbers:'
n = 0
do i = 2 to cycl.0
   a = cycl.i
   if Prime(a) then do
      n = n+1
      if n <= 50 then do
         call Charout ,Right(a,8)
         if n//10 = 0 then
            say
      end
      if a > 1e7 then do
         say 'First such number > 1e7 is' a 'at index' n; say
         leave i
      end
   end
end
return

BlindCyclops:
procedure expose cycl.
say 'First 50 blind prime cyclop numbers:'
n = 0
do i = 2 to cycl.0
   a = cycl.i
   if Prime(a) then do
      l = Length(a); m = l%2; b = Left(a,m)||Right(a,m)
      if Prime(b) then do
         n = n+1
         if n <= 50 then do
            call Charout ,Right(a,8)
            if n//10 = 0 then
               say
         end
         if a > 1e7 then do
            say 'First such number > 1e7 is' a 'at index' n; say
            leave i
         end
      end
   end
end
return

PalindromicCyclops:
procedure expose cycl.
say 'First 50 palindromic prime cyclop numbers:'
n = 0
do i = 2 to cycl.0
   a = cycl.i
   if a = Reverse(a) then do
      if Prime(a) then do
         n = n+1
         if n <= 50 then do
            call Charout ,Right(a,8)
            if n//10 = 0 then
               say
         end
         if a > 1e7 then do
            say 'First such number > 1e7 is' a 'at index' n; say
            leave i
         end
      end
   end
end
return

include Sequences
include Numbers
include Functions
include Abend
