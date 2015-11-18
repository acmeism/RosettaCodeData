/*REXX program calculates and displays some values for the Ackermann function.*/
high=24
         do j=0  to 3;   say
             do k=0  to high%(max(1,j))
             call Ackermann_tell  j,k
             end   /*k*/
         end       /*j*/
exit                                   /*stick a fork in it,  we're all done. */
/*──────────────────────────────────ACKERMANN_TELL subroutine─────────────────*/
ackermann_tell: parse arg mm,nn;   calls=0          /*display an echo message.*/
#=right(nn,length(high))
say 'Ackermann('mm","#')='right(ackermann(mm,nn),high),
                           left('',12)   'calls='right(calls,high)
return
/*──────────────────────────────────ACKERMANN subroutine──────────────────────*/
ackermann: procedure expose calls      /*compute value of  Ackermann function.*/
parse arg m,n;      calls=calls+1
if m==0 then return n+1
if n==0 then return ackermann(m-1,1)
if m==2 then return n*2+3
             return ackermann(m-1,ackermann(m,n-1))
