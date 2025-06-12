-- 12 Apr 2025
include Settings

call Time('r')
say 'SIEVE OF PRITCHARD'
say version
say
call Pritchard 150,1
call Pritchard 1e6,0
call Eratosthenes 1e6
exit

Pritchard:
procedure
call Time('r')
arg xx,yy
say 'Primes up to' xx 'by Pritchard...'
memb. = 0; memb.1 = 1; mcpy. = 0; prim. = 0; nwpr. = 0
nl = 2; nn = 0; pr = 2; rl = Sqrt(xx); sl = 1; ub = xx+1
do while pr <= rl
   if sl < xx then do
      do w = 1 to ub
         if memb.w then do
            n = w+sl
            do while n <= nl
               memb.n = 1; n = n+sl
            end
         end
      end
      sl = nl
   end
   do i = 1 to ub
      mcpy.i = memb.i
   end
   np = 5
   do i = 1 to ub
      if mcpy.i then do
         if np = 5 then
            if i > pr then
               np = i
         n = pr*i
         if n > xx then
            leave i
         memb.n = 0
      end
   end
   if np < pr then
      leave
   nn = nn+1
   prim.nn = pr
   if pr = 2 then
      pr = 3
   else
      pr = np
   nl = Min(sl*pr,xx)
end
nwpr. = 0
do i = 2 to ub
   if memb.i then
      nwpr.i = i
end
nn = 0
do i = 1 to 1000
   if prim.i > 0 then do
      if yy then
         call Charout ,prim.i' '
      nn = nn+1
   end
end
do i = 1 to ub
   if nwpr.i > 0 then do
      if yy then
         call Charout ,i' '
      nn = nn+1
   end
end
if yy then
   say
say nn 'found'
say Format(Time('e'),,3) 'seconds'
say
return nn

Eratosthenes:
procedure
call Time('r')
arg xx
say 'Primes up to' xx 'by Eratosthenes...'
say Primes(xx) 'found'
say Format(Time('e'),,3) 'seconds'
return

include Sequences
include Functions
include Abend
