/*REXX program displays an ASCII diagram of a Canter Set as a set of (character) lines. */
w= linesize()                                    /*obtain the width of the display term.*/
if w==0  then w= 81                              /*Can't obtain width?  Use the default.*/
                   do lines=0;   _ = 3 ** lines  /*calculate powers of three  (# lines).*/
                   if _>w  then leave            /*Too large?  We passed the max value. */
                   #=_                           /*this value of a width─of─line is OK. */
                   end   /*lines*/               /* [↑]  calculate a useable line width.*/
w= #                                             /*use the (last) useable line width.   */
$= copies('■', #)                                /*populate the display line with blocks*/
                   do j=0  until #==0            /*show Cantor set as a line of chars.  */
                   if j>0  then do k=#+1  by  #+#  to w         /*skip 1st line blanking*/
                                $= overlay( left('', #), $, k)  /*blank parts of a line.*/
                                end   /*j*/
                   say $                         /*display a line of the Cantor Set.    */
                   #= # % 3                      /*the part (thirds) to be blanked out. */
                   end   /*j*/                   /*stick a fork in it,  we're all done. */
