/*REXX pgm generates (& maybe shows) some Kaprekar numbers using the cast─out─nines test*/
                 /*╔═══════════════════════════════════════════════════════════════════╗
                   ║ Kaprekar numbers were thought of by the mathematician from India, ║
                   ║ Shri Dattathreya Ramachardra Kaprekar  (1905 ───► 1986).          ║
                   ╚═══════════════════════════════════════════════════════════════════╝*/
parse arg A B .                                  /*get optional arguments from the C.L. */
if A=='' | A=","  then A=    10000               /*Not specified?  Then use the default.*/
if B=='' | B=","  then B= -1000000               /* "      "         "   "   "     "    */
call Kaprekar          A                         /*gen Kaprekar numbers,        show 'em*/
call Kaprekar          B                         /* "     "        "      don't show 'em*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Kaprekar: procedure; parse arg N; #=0; aN=abs(N) /*set counter to zero; use  │N│  value.*/
          numeric digits max(9, 2*length(N**2))  /*use enough decimal digits for square.*/
          if aN>1  then call tell 1              /*unity is defined to be a Kaprekar #. */
                                                 /*handle the case of  N  being unity.  */
          if aN>1  then do j=2  for aN-2;  s=j*j /*calculate the square of  J.*/
                        if j//9 \== s//9  then iterate     /*flunked  cast─out─9s  test?*/
                                                           /* //  is REXX's ÷ remainder.*/
                            do k=1  for  length(s) % 2     /*  %   "   "    ÷ [integer].*/
                            if j==left(s,k)+substr(s,k+1) then do; call tell j; leave; end
                            end   /*k*/
                        end       /*j*/
          say
          say center(" There're "    #    ' Kaprekar numbers below '     aN || ., 79, "═")
          return
/*──────────────────────────────────────────────────────────────────────────────────────*/
tell:     #=#+1;  if N>0  then say right(arg(1), digits());   return  /*maybe display it*/
