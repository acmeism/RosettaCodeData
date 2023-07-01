/*rexx program  demonstrates  how to convert a number of seconds  to  bigger time units.*/
parse arg @;  if @=''  then @=7259 86400 6000000 /*Not specified?  Then use the default.*/

       do j=1  for words(@);       z= word(@, j) /* [↓]  process each number in the list*/
       say right(z, 25) 'seconds:  '  convSec(z) /*convert a number to bigger time units*/
       end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
convSec: parse arg x                             /*obtain a number from the argument.   */
         w= timeU( 60*60*24*7,  'wk'  )          /*obtain number of weeks     (if any). */
         d= timeU( 60*60*24  ,  'd'   )          /*   "      "    " days        "  "    */
         h= timeU( 60*60     ,  'hr'  )          /*   "      "    " hours       "  "    */
         m= timeU( 60        ,  'min' )          /*   "      "    " minutes     "  "    */
         s= timeU( 1         ,  'sec' )          /*   "      "    " seconds     "  "    */
         if x\==0  then s=word(s 0, 1) + x 'sec' /*handle fractional (residual) seconds.*/
         $=strip(space(w d h m s),,",");      if $==''  then z= 0 "sec"  /*handle 0 sec.*/
         return  $
/*──────────────────────────────────────────────────────────────────────────────────────*/
timeU:   parse arg u,$;   _= x%u;   if _==0  then return '';   x= x - _*u;   return _ $","
