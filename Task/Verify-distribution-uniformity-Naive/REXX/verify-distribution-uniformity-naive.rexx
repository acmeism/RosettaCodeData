/*REXX program  simulates a number of trials  of a  random digit  and show it's skew %. */
parse arg func times delta seed .                /*obtain arguments (options) from C.L. */
if  func=='' |  func==","   then  func= 'RANDOM' /*function not specified?  Use default.*/
if times=='' | times==","   then times= 1000000  /*times     "      "        "     "    */
if delta=='' | delta==","   then  delta= 1/2     /*delta%    "      "        "     "    */
if datatype(seed, 'W')  then call random ,,seed  /*use some RAND seed for repeatability.*/
highDig=9                                        /*use this var for the highest digit.  */
!.=0                                             /*initialize all possible random trials*/
      do times                                   /* [↓]  perform a bunch of trials.     */
      if func=='RANDOM'  then ?= random(highDig)                  /*use RANDOM function.*/
                         else interpret '?=' func "(0,"highDig')' /* " specified   "    */
      !.?= !.? + 1                                        /*bump the invocation counter.*/
      end   /*t*/                                /* [↑]  store trials ───► pigeonholes. */
                                                 /* [↓]  compute the digit's skewness.  */
g= times /  (1 + highDig)                        /*calculate number of each digit throw.*/
w= max(9, length( commas(times) ) )              /*maximum length of  number  of trials.*/
pad= left('', 9)                                 /*this is used for output indentation. */
say pad  'digit'   center(" hits", w)    ' skew '    "skew %"    'result'     /*header. */
say pad  '─────'   center('', w, '─')    '──────'    "──────"    '──────'     /*hdr sep.*/
                                                 /** [↑]  show header and the separator.*/
      do k=0  to highDig                         /*process each of the possible digits. */
      skew= g - !.k                              /*calculate the  skew   for the digit. */
      skewPC= (1 - (g - abs(skew)) / g) * 100    /*    "      "    "  percentage for dig*/
      say pad center(k, 5)                 right( commas(!.k), w)        right(skew, 6) ,
          right( format(skewPC, , 3), 6)   center( word('ok skewed', 1+(skewPC>delta)), 6)
      end   /*k*/

say pad   '─────'    center('', w, '─')    '──────'   "─────"   '──────'  /*separator.  */
y= 5+1+w+1+6+1+6+1+6                                                      /*width + seps*/
say pad center(" (with  "  commas(times)   '  trials)'  , y)              /*# trials.   */
say pad center(" (skewed when exceeds "      delta'%)'  , y)              /*skewed note.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg _;  do jc=length(_)-3  to 1  by -3; _=insert(',', _, jc); end;  return _
