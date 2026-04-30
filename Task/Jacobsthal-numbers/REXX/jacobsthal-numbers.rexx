-- 25 Apr 2026
include Setting
numeric digits 250

say 'JACOBSTHAL NUMBERS'
say version
say
call Jacobsthal1 29
call Show1 'Jacobsthal',29
call Jacobsthal2 29
call Show1 'Jacobsthal-Lucas',29
call Jacobsthal3 19
call Show1 'Jacobsthal oblong',19
call Jacobsthal1 750
call Show2 'Jacobsthal',21
call Timer
exit

Jacobsthal1:
-- Get Jacobsthal numbers
procedure expose Jaco.
arg xx
a=0; b=1
Jaco.0=a; Jaco.1=b
do i=2 to xx
   c=b+2*a; Jaco.i=c; a=b; b=c
end
return

Jacobsthal2:
-- Get Jacobsthal-Lucas numbers
procedure expose Jaco.
arg xx
a=2; b=1
Jaco.0=a; Jaco.1=b
do i=2 to xx
   c=b+2*a; Jaco.i=c; a=b; b=c
end
return

Jacobsthal3:
-- Get Jacobsthal oblong numbers
procedure expose Jaco.
arg xx
a=0; b=1; c=3
Jaco.0=a; Jaco.1=b; Jaco.2=c
do i=3 to xx
   d=3*c+6*b-8*a; Jaco.i=d; a=b; b=c; c=d
end
return

Show1:
-- Display Jacobsthal numbers
procedure expose Jaco.
parse arg header,count
say 'First' count+1 header 'numbers'
say
do i=0 to count
   call CharOut ,Right(Jaco.i,12)
   if i//10=4 | i//10=9 then
      say
end
say
return

Show2:
-- Display Jacobsthal primes
procedure expose Jaco. Memo.
parse arg header,count
say 'First' count header 'Primes'
say
say 'No Seq Prime'
n=0
do i=0 until n=count
   if Prime(Jaco.i) then do
      n+=1
      say Right(n,2) Right(i,3) Jaco.i '('Xpon(jaco.i)+1 'digits)'
   end
end
say 'No 22 in this sequence (Seq 1709 is prime > 500 digits) could not be reached within reasonable time.'
say
return

-- Prime; Timer
include Math
