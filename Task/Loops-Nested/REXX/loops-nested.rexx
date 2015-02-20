/*REXX program loops through a 2-dimensional array to look for a  '20'. */
parse arg rows cols targ .             /*obtain optional args from C.L. */
if rows=='' | rows==','  then rows=60  /*Rows not specified? Use default*/
if cols=='' | cols==','  then cols=10  /*Cols  "      "       "     "   */
if targ=='' | targ==','  then targ=20  /*Targ  "      "       "     "   */
w=max(length(rows),length(cols),length(targ))   /*for formatting output.*/
not='not'                              /* [↓] construct the 2-dim array.*/
          do     row=1  for rows       /*1st dimension of the array.    */
              do col=1  for cols       /*2nd     "      "  "    "       */
              @.row.col=random(1,targ) /*generate some random numbers.  */
              end   /*row*/
          end       /*col*/
/*═════════════════════════════════════now, search for the target  {20}.*/
          do     r=1  for rows
              do c=1  for cols
              say left('@.'r"."c,3+w+w) '=' right(@.r.c,w)    /*display.*/
              if @.r.c==targ  then do; not=; leave r; end     /*found ? */
              end   /*c*/
          end       /*r*/

say right(space('Target'  not  'found:')  targ, 33, '─')
                                       /*stick a fork in it, we're done.*/
