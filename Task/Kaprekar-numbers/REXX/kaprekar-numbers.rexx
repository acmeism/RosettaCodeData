/*REXX pgm generates & counts (+ maybe shows) some Kaprekar #s using the cast─out─9 test*/
                 /*╔═══════════════════════════════════════════════════════════════════╗
                   ║ Kaprekar numbers were thought of by the mathematician from India, ║
                   ║ Shri Dattathreya Ramachardra Kaprekar  (1905 ───► 1986).          ║
                   ╚═══════════════════════════════════════════════════════════════════╝*/
parse arg A B .                                  /*obtain optional arguments from the CL*/
if A=='' | A=","  then A=    10000               /*Not specified?  Then use the default.*/
if B=='' | B=","  then B= -1000000               /* "      "         "   "   "     "    */
call Kaprekar          A                         /*gen Kaprekar numbers,        show 'em*/
call Kaprekar          B                         /* "     "        "      don't show 'em*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Kaprekar: procedure; parse arg N; #=0; aN=abs(N) /*set counter to zero; use  │N│  value.*/
          numeric digits max(9, 2*length(N) )    /*use enough decimal digits for square.*/
          if aN>0  then call tell 1              /*unity is defined to be a Kaprekar #. */
                                                 /* [↑]  handle case of  N  being unity.*/
          if aN>1  then do j=9  for aN-9         /*calculate the  square  of  J   (S).  */
                        if j//9 >2  then iterate /*Is  J mod 9 > two?  Then skip this J.*/
                        s= j*j                   /*calculate the  square  of  J   (S).  */
                        if j//9==s//9  then do k=1  for length(s)%2  /*≡ casted out 9's?*/
                                            parse var    s      L   +(k)   R
                                            if j==L+R  then do;  call tell j;  leave;  end
                                            end   /*k*/
                        end   /*j*/
          say
          say center(" There're "    #    ' Kaprekar numbers below '     aN || ., 79, "═")
          return
/*──────────────────────────────────────────────────────────────────────────────────────*/
tell:     #=#+1;  if N>0  then say right(arg(1), digits());   return  /*maybe display it*/
