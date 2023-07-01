/*REXX program loops through a two-dimensional array to search for a  '20'    (twenty). */
parse arg rows cols targ .                       /*obtain optional arguments from the CL*/
if rows=='' | rows==","  then rows=60            /*Rows not specified?  Then use default*/
if cols=='' | cols==","  then cols=10            /*Cols  "      "         "   "     "   */
if targ=='' | targ==","  then targ=20            /*Targ  "      "         "   "     "   */
w=max(length(rows), length(cols), length(targ))  /*W:  used for formatting the output.  */
not= 'not'                                       /* [↓]  construct the 2─dimension array*/
          do     row=1  for rows                 /*ROW  is the 1st dimension of array.  */
              do col=1  for cols                 /*COL   "  "  2nd     "      "   "     */
              @.row.col=random(1, targ)          /*create some positive random integers.*/
              end   /*row*/
          end       /*col*/

          do     r=1  for rows    /* ◄───────────────── now, search for the target {20}.*/
              do c=1  for cols
              say left('@.'r"."c, 3+w+w) '=' right(@.r.c, w)    /*show an array element.*/
              if @.r.c==targ  then do; not=; leave r; end       /*found the targ number?*/
              end   /*c*/
          end       /*r*/

say right( space( 'Target'  not  "found:" )    targ, 33, '─')
                                                 /*stick a fork in it,  we're all done. */
