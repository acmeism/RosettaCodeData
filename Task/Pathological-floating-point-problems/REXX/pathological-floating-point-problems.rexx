-- 28 Jul 2025
include Settings
arg digs
if digs = '' then
   digs=9
numeric digits digs

say 'PATHOLOGICAL FLOATING POINT PROBLEMS'
say version
say digs 'digits precision'
say
call Sequence
call Society
call Rump
call Timer
exit

Sequence:
procedure
say 'Sequence goes to wrong limit...'
show='3 4 5 6 7 8 20 30 50 100'
a=2; b=-4
do n = 3 to 100
   c=111-1130/b+3000/(a*b); a=b; b=c
   if Wordpos(n,show) > 0 then
      say 'n =' Right(n,3) Left(c,19)
end
say
return

Society:
procedure expose Memo.
say 'The Chaotic Bank Society...'
e=e()/1; b=e-1
say Right(0,2) Left(b,18)
do n = 1 to 25
   b=b*n-1
   say Right(n,2) Left(b,18)
end
say
return

Rump:
procedure
say 'Siegfried Rumps''s example...'
a=77617; b=33096
say Left(333.75*b**6 + a**2*(11*a**2*b**2-b**6-121*b**4-2) + 5.5*b**8 + a/(2*b),18)
say
return

include Math
