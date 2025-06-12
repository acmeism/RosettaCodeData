-- 22 Mar 2025
include Settings

say 'UNPRIMEABLE NUMBERS'
say version
say
call GetPrimes
call GetUnprimes
call Task1
call Task2
call GetLowest
call Task3
exit

GetPrimes:
procedure expose prim. flag.
call Time('r')
say 'Get primes up to 10 million...'
call Primes 1e7
say prim.0 'primes found'
say Format(Time('e'),,3) 'seconds'; say
return

GetUnprimes:
procedure expose flag. unpr.
call Time('r')
say 'Get unprimeable numbers up to 1.3 million...'
unpr. = 0; n = 0
do i = 100 to 1.3e6
   if \ flag.i then do
      a = 1; b = Length(i)
      do j = a to b
         c = Substr(i,j,1)
         do k = 0 to 9
            d = Left(i,j-1)||k||Right(i,b-j); d = d+0
            if flag.d then
               iterate i
         end
      end
      n = n+1; unpr.n = i
   end
end
unpr.0 = n
say unpr.0 'unprimeable numbers found'
say Format(Time('e'),,3) 'seconds'; say
return

Task1:
procedure expose unpr.
call Time('r')
say 'The first 35 unprimeable numbers are'
do i = 1 to 35
   call Charout ,Right(unpr.i,4)
end
say
say Format(Time('e'),,3) 'seconds'; say
return

Task2:
procedure expose unpr.
call Time('r')
say 'The 600th unprimeable number is'
say unpr.600
say Format(Time('e'),,3) 'seconds'; say
return

GetLowest:
procedure expose unpr. lowu.
call Time('r')
say 'Get lowest unprimeable number per digit...'
lowu. = 0
do i = 1 to unpr.0
   a = Right(unpr.i,1)
   if lowu.a = 0 then
      lowu.a = unpr.i
end
say Format(Time('e'),,3) 'seconds'; say
return

Task3:
procedure expose lowu.
call Time('r')
say 'Dig  Lowest'
say '-----------'
do i = 0 to 9
   say Right(i,3) Right(lowu.i,7)
end
say '-----------'
say Format(Time('e'),,3) 'seconds'; say
return

include Functions
include Sequences
include Abend
