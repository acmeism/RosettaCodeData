/*REXX program calculates/shows some values for the Ackermann function. */
high=24
         do j=0 to 3;   say
              do k=0 to high%(max(1,j))
              call Ackermann_tell j,k
              end   /*k*/
         end        /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*ââââââââââââââââââââââââââââââââââACKERMANN_TELL subroutineâââââââââââ*/
ackermann_tell: parse arg mm,nn;   calls=0    /*display an echo message.*/
nnn=right(nn,length(high))
say 'Ackermann('mm","nnn')='right(ackermann(mm,nn),high),
                             left('',12) 'calls='right(calls,10)
return
/*ââââââââââââââââââââââââââââââââââACKERMANN subroutineââââââââââââââââ*/
ackermann: procedure expose calls      /*compute the Ackerman function. */
parse arg m,n;      calls=calls+1
if m==0 then return n+1
if n==0 then return ackermann(m-1,1)
if m==2 then return n*2+3
             return ackermann(m-1,ackermann(m,n-1))
