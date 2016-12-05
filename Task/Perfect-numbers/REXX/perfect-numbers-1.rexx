/*REXX version of the  ooRexx  program (the code was modified to run with Classic REXX).*/
      do i=1  to 10000                                 /*statement changed:  LOOP ──► DO*/
      if perfectNumber(i)  then say  i   "is a perfect number"
      end
exit

perfectNumber: procedure; parse arg n                  /*statements changed: ROUTINE,USE*/
sum=0
             do i=1  to n%2                            /*statement changed:  LOOP ──► DO*/
             if n//i==0 then sum=sum+i                 /*statement changed:  sum += i   */
             end
return sum=n
