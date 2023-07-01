/* REXX ---------------------------------------------------------------
* 30.06.2014 Walter Pachl
*--------------------------------------------------------------------*/
parse arg l
say '         array list:' strip(l)
x.=0
Do i=1 To words(l)
  x.i=word(l,i)
  End
n=i-1
ans=strip(equilibriumIndices())
n=words(ans)
Select
  When n=0 Then Say 'There''s no equilibrium index'
  When n=1 Then Say 'equilibrium index  :' ans
  Otherwise     Say 'equilibrium indices:' ans
  End
Say '---'
exit
equilibriumIndices: procedure expose x. n
sum.=0
sum=0
eil=''
Do i=1 To n
  sum=sum+x.i
  sum.i=sum
  End
Do i=1 To n
  im1=i-1
  If sum.im1=(sum.n-x.i)/2 Then
    eil=eil im1
  End
Return eil
