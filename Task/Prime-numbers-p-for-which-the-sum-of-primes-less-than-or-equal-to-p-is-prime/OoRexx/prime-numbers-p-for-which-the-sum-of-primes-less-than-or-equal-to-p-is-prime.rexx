/* paul2o.rex */
np=primes(80000)
say stemget(prim.,np)
sum=0
Say 'prime         prime'
Say 'count  prime    sum'
Do i=1 To np
  prim.i=stemget(prim.,i)
  sum=sum+prim.i
  If stemget(flag.,sum) Then
    Say right(i,5) right(prim.i,6) right(sum,6)
  End
Call timer
::REQUIRES math
