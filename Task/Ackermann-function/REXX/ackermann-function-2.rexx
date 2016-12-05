/*REXX program  calculates and displays  some values for the  Ackermann function.       */
high=24
         do     j=0  to 3;                    say
             do k=0  to high % (max(1, j))
             call tell_Ack  j, k
             end   /*k*/
         end       /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
tell_Ack:  parse arg mm,nn;   calls=0            /*display an echo message to terminal. */
           #=right(nn,length(high))
           say 'Ackermann('mm", "#')='right(ackermann(mm, nn), high),
                                      left('', 12)     'calls='right(calls, high)
           return
/*──────────────────────────────────────────────────────────────────────────────────────*/
ackermann: procedure expose calls                /*compute value of Ackermann function. */
           parse arg m,n;   calls=calls+1
           if m==0  then return n + 1
           if n==0  then return ackermann(m-1, 1)
           if m==2  then return n + 3 + n
                         return ackermann(m-1, ackermann(m, n-1) )
