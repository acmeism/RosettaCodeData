/*REXX pgm simulates a number of trials of a random digit and show it's skew %*/
parse arg f t d s .                    /*obtain arguments (options) from C.L. */
if f=='' | f==',' then f='RANDOM'      /*function not specified?  Use default.*/
if t=='' | t==',' then t=1000000       /*times     "      "        "     "    */
if d=='' | d==',' then d=1/2           /*delta%    "      "        "     "    */
if s\==''         then call random ,,s /*use some RAND seed for repeatability.*/
highDig=9                              /*use this var for the highest digit.  */
!.=0                                   /*initialize all possible random trials*/
      do t                             /* [↓]  perform a bunch of trials.     */
      if f=='RANDOM'  then ?=random(0,highDig)              /*random function.*/
                      else interpret '?='f"(0,"highDig')'   /* user  function.*/
      !.?=!.?+1                                             /*bump the counter*/
      end   /*t*/                      /* [↑]  store trials ───► pigeonholes. */
                                       /* [↓]  compute the digit's skewness.  */
g=t/(1+highDig)                        /*calculate number of each digit throw.*/
OK?='OK skewed'                        /*words to show  "skewed"  or if  "OK".*/
w=max(8,length(t))                     /*maximum length of  number  of trials.*/
pad=left('',9)                         /*this is used for output indentation. */
say pad 'digit' center("hits",w)  ' skew '   "skew%"   'result'   /*header.   */
say pad '─────' center('',w,'─')  '──────'   "─────"   '──────'   /*separator.*/
                                       /** [↑]  show header and the separator.*/
  do k=0  to highDig                   /*process each of the possible digits. */
  skew=g-!.k                           /*calculate the  skew   for the digit. */
  skewPC=(1-(g-abs(skew))/g)*100       /*    "      "    "  percentage for dig*/
  ok=center(word(ok?,1+(skewPC>d)),6)  /*it's gotta be one of  skewed  or  xx%*/
  say pad center(k,5) right(!.k,w) right(skew,6) format(skewPC,,3) ok
  end   /*k*/

say pad '─────'  center('',w,'─')  '──────'  "─────"  '──────'   /*separator. */
y=5+1+w+1+6+1+6+1+6                                              /*the width. */
say pad center(" (with "   t   ' trials)',y)                     /*# trials.  */
say pad center(" (skewed when exceeds " d'%)',y)                 /*skewed note*/
                                       /*stick a fork in it,  we're all done. */
