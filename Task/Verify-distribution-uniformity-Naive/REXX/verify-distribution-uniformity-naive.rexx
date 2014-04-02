/*REXX pgm simulates a # of trials of a random digit, show it's skew %. */
parse arg f t d s .                    /*obtain arguments (options).    */
if f=='' | f==',' then f='RANDOM'      /* func ¬specified?  Use default.*/
if t=='' | t==',' then t=1000000       /*times      "        "     "    */
if d=='' | d==',' then d=1/2           /*delta%     "        "     "    */
if s\==''         then call random ,,s /*use some seed for repeatibility*/
highDig=9                              /*use this for the highest digit.*/
!.=0                                   /*zero all possible random trials*/
      do j=1  for t                    /* [↓]  perform a lot of trials. */
      if f=='RANDOM'  then ?=random(0,highDig)            /*random func.*/
                      else interpret '?='f"(0,"highDig')' /* user  func.*/
      !.?=!.?+1                                           /*bump counter*/
      end   /*j*/                      /* [↑]  trials ───► pigeonholes. */
                                       /* [↓]  compute the dig skewness.*/
g=t/(1+highDig)                        /*calculate # of each digit throw*/
OK?='OK skewed'                        /*words to show skewed or if OK. */
w=max(8,length(t))                     /*maximum length of # of trials. */
pad=left('',9)                         /*this is used for indentation.  */
say pad 'digit' center("hits",w)  ' skew '   "skew%"   'result'  /*hdr. */
say pad '─────' center('',w,'─')  '──────'   "─────"   '──────'  /*sep. */
                                       /** [↑]  show header & separator.*/
  do k=0  to highDig                   /*process each of the possible #.*/
  skew=g-!.k                           /*calculate the skew for the dig.*/
  skewPC=(1-(g-abs(skew))/g)*100       /*    "      "    "  percentage. */
  ok=right(word(ok?,1+(skewPC>d)),6)   /*it's gotta be one or the other.*/
  say pad center(k,5) right(!.k,w) right(skew,6) format(skewPC,,3) ok
  end   /*k*/

say pad '─────' center('',w,'─')  '──────'   "─────"   '──────'  /*sep. */
y=5+1+w+1+6+1+6+1+6                                              /*width*/
say pad center(" (with "  t  ' trials)',y)                       /*info.*/
say pad center(" (skewed when exceeds " d'%)',y)                 /*info.*/
                                       /*stick a fork in it, we're done.*/
