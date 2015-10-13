/*REXX program displays a   NxN    multiplication table   (in a boxed grid).  */
parse arg high .                       /*get optional grid size from the C.L. */
if high==''  then high=12              /*Not specified?  Then use the default.*/
       bar  = '│'    ;    dash = '─'   /*(vertical) bar; horizontal bar (dash)*/
       bj   = '┴'    ;    tj   = '┬'   /*bottom and top junctions  (or  tees).*/
       cj   = '┼'                      /*center junction  (or cross).         */
       lj   = '├'    ;    rj   = '┤'   /*left and right junctions  (or  tees).*/
       tlc  = '┌'    ;    trc  = '┐'   /* top     left and right corners.     */
       blc  = '└'    ;    brc  = '┘'   /*bottom     "   "    "      "         */
                                       /* [↑]  define stuff to hold box glyphs*/
cell = cj || copies(dash, 5)           /*define the top of the cell.          */
sep  = copies(cell, high+1)rj          /*build the table separator.           */
sepL = length(sep)                     /*length of the separator line.        */
width= length(cell)-1                  /*width of the table cells.            */
size = width-1                         /*width for the table numbers.         */
box. = left('', width)                 /*construct all the cells.             */

     do j=0  to high                   /*step through  zero  ───►  high.      */
     _=right(j, size-1)'x '            /*build the  "label" (border) number.  */
     box.0.j=_                         /*build the   top label cell.          */
     box.j.0=_                         /*build the  left label cell.          */
     end   /*j*/

box.0.0=centre('times', width)         /*redefine   box.0.0   with  'X'.      */

     do   row=1   for high             /*step through   one  ───►  high.      */
       do col=row  to high             /*step through   row  ───►  high.      */
       box.row.col=right(row*col, size)' '    /*build a multiplication cell.  */
       end   /*col*/
     end     /*row*/

  do row=0  to high                    /*step through all the lines.          */
  asep=sep                             /*allow use of a modified separator.   */
  if row==0  then do
                  asep=overlay(tlc, asep, 1)          /*make a better  tlc.   */
                  asep=overlay(trc, asep, sepL)       /*make a better  trc.   */
                  asep=translate(asep, tj ,cj)        /*make a better   tj.   */
                  end
             else asep=overlay(lj, asep ,1)           /*make a better   lj.   */

  say asep                             /*display a table grid line.           */
  if row==0  then call buildLine 00    /*display a blank grid line.           */
                  call buildLine row   /*build one line of the grid.          */
  if row==0  then call buildLine 00    /*display a blank grid line.           */
  end   /*row*/

asep=sep                               /*allow use of a modified separator.   */
asep=overlay(blc, asep, 1)             /*make a better  bottom  left corner.  */
asep=overlay(brc, asep, sepL)          /*make a better  bottom right corner.  */
asep=translate(asep, bj, cj)           /*make a better  bottom junction.      */
say asep                               /*display a table grid line.           */
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
buildLine:  w=;   parse arg arow       /*start with a blank cell.             */

               do col=0  to high       /*step through  zero  ───►  high.      */
               w=w||bar||box.arow.col  /*build one cell at a time.            */
               end   /*col*/
say w || bar                           /*finish building the last cell.       */
return
