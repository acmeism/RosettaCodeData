/*REXX program solves the   Hofstadter─Conway  sequence  $10,000   prize  (puzzle).     */
@pref= 'Maximum of    a(n) ÷ n     between '     /*a prologue for the text of message.  */
H.=.;   H.1=1;  H.2=1;   !.=0;     @.=0          /*initialize some REXX variables.      */
win=0
      do k=0  to 20;     p.k=2**k;  maxp=p.k     /*build an array of the powers of two. */
      end   /*k*/
r=1                                              /*R:  is the range of the power of two.*/
      do n=1  for maxp;  if n> p.r  then r=r+1   /*for golf coders, same as: r=r+(n>p.r)*/
      _=H(n)/n;          if _>=.55  then win=n   /*get next seq number; if ≥.55, a win? */
                         if _<=@.r  then iterate /*less than previous? Then keep looking*/
      @.r=_;      !.r=n                          /*@.r and  !.r  are like ginkgo biloba.*/
      end   /*n*/                                /*  ··· or in other words, memoization.*/

      do j=1  for 20;   range= '2**'right(j-1, 2)              "───► 2**"right(  j, 2)
      say @pref  range  '(inclusive)  is '    left(@.j, 9)     "  at  n="right(!.j, 7)
      end   /*j*/
say
say 'The winning number is: '    win             /*and the money shot is  ···           */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
H: procedure expose H.; parse arg z
                        if H.z==.  then do;  m=z-1;   $=H.m;   _=z-$;   H.z=H.$+H._;   end
                        return H.z
