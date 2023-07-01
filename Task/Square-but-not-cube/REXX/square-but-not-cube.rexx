/*REXX pgm shows N ints>0 that are squares and not cubes, & which are squares and cubes.*/
numeric digits 20                                /*ensure handling of larger numbers.   */
parse arg N .                                    /*obtain optional argument from the CL.*/
if N=='' | N==","  then N= 30                    /*Not specified?  Then use the default.*/
sqcb= N<0                                        /*N negative? Then show squares & cubes*/
N = abs(N)                                       /*define  N  to be the absolute value. */
w= (length(N) + 3)  *  3                         /*W:  used for aligning output columns.*/
say '   count   '                                /*display the  1st  line of the title. */
say '  ───────  '                                /*   "     "   2nd    "   "  "    "    */
@.= 0                                            /*@:  stemmed array for computed cubes.*/
                   #= 0;  ##= 0                  /*count (integer): squares & not cubes.*/
     do j=1  until #==N | ##==N                  /*loop 'til enough    "    "  "    "   */
     sq= j*j;          cube= sq*j;    @.cube= 1  /*compute the square of J and the cube.*/
     if @.sq  then do
                   ##= ## + 1                    /*bump the counter of squares & cubes. */
                   if \sqcb  then counter=   left('', 12)     /*don't show this counter.*/
                             else counter= center(##, 12)     /*  do    "    "     "    */
                   say counter        right(commas(sq), w)  'is a square and       a cube'
                   end
              else do
                   if sqcb  then  iterate
                   #= # + 1                      /*bump the counter of squares & ¬ cubes*/
                   say center(#, 12)  right(commas(sq), w)  'is a square and  not  a cube'
                   end
     end   /*j*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
