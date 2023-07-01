/*REXX pgm runs the EGYPTIAN program to find biggest denominator & # of terms.*/
parse arg top .                        /*get optional parameter from the C.L. */
if top==''  then top=99                /*Not specified?  Then use the default.*/
oTop=top;   top=abs(top)               /*oTop used as a flag to display maxD. */
maxT=0;     maxD=0;     bigD=;   bigT= /*initialize some REXX variables.      */
                                       /* [↓]  determine biggest andlongest.  */
      do n=2      to top               /*traipse through the  numerators.     */
          do d=n+1  to top             /*   "       "     "  denominators     */
          fract=n'/'d                  /*create the fraction to be used.      */
          y='EGYPTIAN'(fract||.)       /*invoke the REXX program  EGYPTIAN.REX*/
          t=words(y)                   /*number of terms in Egyptian fraction.*/
          if t>maxT  then bigT=fract   /*is this a new high for number terms? */
          maxT=max(maxT,T)             /*find the maximum number of terms.    */
          b=substr(word(y,t),3)        /*get denominator from Egyptian fract. */
          if b>maxD  then bigD=fract   /*is this a new denominator high ?     */
          maxD=max(maxD,b)             /*find the maximum denominator.        */
          end   /*d*/                  /* [↑]  only use proper fractions.     */
      end       /*n*/                  /* [↑]  ignore the   1/n   fractions.  */
                                       /* [↑]  display the longest and biggest*/
@= 'in the Egyptian fractions used is' /*literal is used to make a shorter SAY*/
say 'largest number of terms'  @   maxT   "terms for"   bigT
say
say 'highest denominator'      @   length(maxD)   "digits for"  bigD
if oTop>0  then say maxD               /*stick a fork in it,  we're all done. */
