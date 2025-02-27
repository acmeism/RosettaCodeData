include Settings

say version; say 'Cyclops numbers'; say
numeric digits 10; cycl. = 0
call GetCyclops 115e6
call Cyclops
call PrimeCyclops
call BlindPrimeCyclops
call PalPrimeCyclops
say Format(Time('e'),,3) 'seconds'
exit

GetCyclops:
procedure expose cycl.
arg x
m = 0; n = 1; cycl.cyclop.1 = 0
do f = 1
   h = m+1; m = n
   do j = 1 to 9
      do i = h to m
         a = cycl.cyclop.i
         do k = 1 to 9
            b = j||a||k
            if b > x then
               leave f
            n = n+1; cycl.cyclop.n = b
         end
      end
   end
end
cycl.0 = n
say n 'cyclops numbers generated <' x; say
return

Cyclops:
procedure expose cycl.
say 'First 50 cyclop numbers:'
do i = 1 to cycl.0
   a = cycl.cyclop.i
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
   a = cycl.cyclop.i
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

BlindPrimeCyclops:
procedure expose cycl.
say 'First 50 blind prime cyclop numbers:'
n = 0
do i = 2 to cycl.0
   a = cycl.cyclop.i
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

PalPrimeCyclops:
procedure expose cycl.
say 'First 50 palindromic prime cyclop numbers:'
n = 0
do i = 2 to cycl.0
   a = cycl.cyclop.i
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

include Numbers
include Functions
