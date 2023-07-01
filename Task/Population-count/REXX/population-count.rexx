/*REXX program counts the number of "one" bits in the binary version of a decimal number*/
/*─────────────────── and also generates a specific number of  EVIL and ODIOUS  numbers.*/
parse arg N B .                                  /*get optional arguments from the C.L. */
if N==''  |  N==","   then N= 30                 /*N not specified?   Then use default. */
if B==''  |  B==","   then B=  3                 /*B  "      "          "   "      "    */
numeric digits 2000                              /*be able to handle  gihugeic  numbers.*/
numeric digits max(20, length(B**N) )            /*whittle the  precision  down to size.*/
$=                                               /* [↑]  a little calculation for sizing*/
     do j=0  for  N;   $= $ popCount(B**j)       /*generate N popCounts for some powers.*/
     end   /*j*/                                 /* [↑]  append popCount to the $ list. */
                                                 /* [↓]  display popCounts of "3" powers*/
call showList  'popCounts of the powers of'  B   /*display the list with a header/title.*/

     do j=0  until  #>=N                         /*generate   N   evil  numbers.        */
     if popCount(j) // 2  then iterate           /*if  odd population count, skip it.   */
     #= # + 1;      $= $ j                       /*bump evil # count;  add it to $ list.*/
     end   /*j*/                                 /* [↑]  build a list of evil numbers.  */
                                                 /* [↓]  display the evil number list.  */
call showList  'evil numbers'                    /*display the  $  list with a header.  */

     do j=0  until  #>=N                         /*generate   N   odious  numbers.      */
     if popCount(j) // 2 ==0  then iterate       /*if even population count, then skip. */
     #= # + 1;      $=$ j                        /*bump odious # count;  add to $ list. */
     end   /*j*/                                 /* [↑]  build a list of odious numbers.*/
                                                 /* [↓]  display the odious number list.*/
call showList  'odious numbers'                  /*display the   $  list with a header. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
d2b:      return word( strip( x2b( d2x( arg(1) ) ), 'L', 0)  0, 1)        /*dec ──► bin.*/
popCount: return length( space( translate( d2b(arg(1) ), , 0), 0) )       /*count ones. */
showList: say;   say 'The 1st'   N   arg(1)":";   say strip($);     #= 0;     $=;   return
