/* ppaul.rex */
include setting
np=primes(80000)
sum=0
Say 'prime         prime'
Say 'count  prime    sum'
Do i=1 by 1 while prim.i<1000
  sum=sum+prim.i
  If flag.sum Then
    Say right(i,5) right(prim.i,6) right(sum,6)
  End
Call timer
Exit
include math
