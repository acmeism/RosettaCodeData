/*REXX program calculates/shows some values for the Ackermann function. */

                     /*Note: the Ackermann function (as implemented) is */
                     /*      higly recursive and is limited by the      */
                     /*      biggest number that can have "1" added to  */
                     /*      a number (successfully, accurately).       */
high=24
         do j=0 to 3;   say
              do k=0 to high%(max(1,j))
              call Ackermann_tell j,k
              end   /*k*/
         end        /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ACKERMANN_TELL subroutine───────────*/
ackermann_tell: parse arg mm,nn;   calls=0    /*display an echo message.*/
nnn=right(nn,length(high))
say 'Ackermann('mm","nnn')='right(ackermann(mm,nn),high),
                             left('',12) 'calls='right(calls,high)
return
/*──────────────────────────────────ACKERMANN subroutine────────────────*/
ackermann: procedure expose calls      /*compute the Ackerman function. */
parse arg m,n;      calls=calls+1
if m==0 then return n+1
if n==0 then return ackermann(m-1,1)
             return ackermann(m-1,ackermann(m,n-1))
