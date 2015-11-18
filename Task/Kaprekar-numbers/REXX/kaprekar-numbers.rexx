/*REXX program generates  Kaprekar  numbers  using the  cast-out-nines  test. */
       /*╔═══════════════════════════════════════════════════════════════════╗
         ║ Kaprekar numbers were thought of by the mathematician from India, ║
         ║ Shri Dattathreya Ramachardra Kaprekar  (1905─1986).               ║
         ╚═══════════════════════════════════════════════════════════════════╝*/
parse arg A B .                        /*get optional arguments from the C.L. */
if A=='' | A=','  then A=    10000     /*Not specified?  Then use the default.*/
if B=='' | B=','  then B= -1000000     /* "      "         "   "   "     "    */
call Kaprekar  A                       /*gen Kaprekar #s, with/without an echo*/
call Kaprekar  B                       /* "     "      "    "     "     "  "  */
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
Kaprekar: procedure; parse arg N;   #=0;     aN=abs(N);         call tell 1
          numeric digits max(10,2*length(N**2)) /*insure enough dig for square*/

            do j=2  for aN-1;    s=j*j       /*calculate the square of  J.    */
            if j//9\==s//9  then iterate     /*Flunked cast-out-9s test? Skip.*/

                do k=1  for  length(s) % 2
                if j==left(s,k)+substr(s,k+1)  then call tell j      /*Eureka!*/
                end   /*k*/
            end       /*j*/

          say center("There're"   #   'Kaprekar numbers below'   An".", 79, '═')
          return
/*────────────────────────────────────────────────────────────────────────────*/
tell:     #=#+1;      if N>0  then say right(arg(1), length(N));          return
