/*REXX version of the  ooRexx  pgm (code was modified for Classic REXX).*/

      do i=1 to 10000                  /*statement changed:  LOOP ──► DO*/
      if perfectNumber(i) then say i "is a perfect number"
      end
exit

perfectNumber: procedure; arg n        /*statements changed: ROUTINE,USE*/
sum=0
             do i=1 to  n%2            /*statement changed:  LOOP ──► DO*/
             if n//i==0 then sum=sum+i /*statement changed:  sum += i   */
             end
return sum=n
