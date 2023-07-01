/*REXX program returns the hailstone (Collatz) sequence for any integer.*/
numeric digits 20                      /*ensure enough digits for mult. */
parse arg n 1 s                        /*N & S assigned to the first arg*/
                do  while n\==1        /*loop while  N  isn't  unity.   */
                if n//2  then n=n*3+1  /*if  N  is odd,  calc:   3*n +1 */
                         else n=n%2    /* "  "   " even, perform fast ÷ */
                s=s n                  /*build a sequence list (append).*/
                end   /*while*/
return s
