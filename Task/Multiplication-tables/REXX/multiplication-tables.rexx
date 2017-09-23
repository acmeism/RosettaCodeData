/*REXX program displays a  NxN  multiplication table  (in a boxed grid) to the terminal.*/
parse arg high .                                 /*obtain optional grid size from the CL*/
if high=='' | high==","  then high=12            /*Not specified?  Then use the default.*/
            bar  = '│'   ;    dash = "─"         /*(vertical) bar; horizontal bar (dash)*/
            bj   = '┴'   ;    tj   = "┬"         /*bottom and top junctions  (or  tees).*/
            cj   = '┼'                           /*center junction  (or cross).         */
            lj   = '├'   ;    rj   = "┤"         /*left and right junctions  (or  tees).*/
            tlc  = '┌'   ;    trc  = "┐"         /* top     left and right corners.     */
            blc  = '└'   ;    brc  = "┘"         /*bottom     "   "    "      "         */
cell = cj || copies(dash,max(5,length(high) +1)) /*define the  top  of the cell.        */
sep  = copies(cell, high+1)rj                    /*construct the table separator.       */
size = length(cell) - 1                          /*width for the products in the table. */
box. = left('', size)                            /*initialize all the cells in the table*/
            do j=0  to  high                     /*step through  zero  ───►  high.      */
            _=right(j, size - 2)'x '             /*build the   "label" (border) number. */
            box.0.j=center(_,        size)       /*  "    "     top label cell.         */
            box.j.0=center(_, max(5, size) )     /*  "    "    left label cell.         */
            end   /*j*/
box.0.0=center('times', max(5, size))            /*redefine    box.0.0   with  "times". */
            do   r=1   for high                  /*step through row      one ───► high. */
              do c=r    to high                  /*step through column   row ───► high. */
              box.r.c=right(r*c, size)           /*build a single multiplication cell.  */
              end   /*c*/
            end     /*r*/                        /*only build the top right-half of grid*/

         do r=0  to high;  @=sep;  L=length(sep) /*step through all lines; use a mod sep*/
         if r==0  then do; @=overlay(tlc, @ , 1) /*use a better tlc (top  left corner). */
                           @=overlay(trc, @ , L) /* "  "    "   trc ( "  right    "  ). */
                           @=translate(@, tj,cj) /* "  "    "   tj  (top  junction/tee).*/
                       end
                  else @=overlay(lj, @, 1)       /* "  "    "   lj  (left junction/tee).*/
         say @                                   /*display a single table grid line.    */
         if r==0  then call buildLine 00         /*   "    "    "   blank grid   "      */
                       call buildLine r          /*build a single line of the grid.     */
         if r==0  then call buildLine 00         /*display a single blank grid line.    */
         end   /*r*/
@=sep                                            /*allow use of a modified separator.   */
@=overlay(blc, @ ,  1)                           /*use a better  bottom   left corner.  */
@=overlay(brc, @ , length(sep) )                 /* "  "    "       "    right corner.  */
@=translate(@, bj, cj)                           /* "  "    "       "      junction.    */
say @                                            /*display a (single)  table grid line. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
buildLine: parse arg row,,$;    do col=0  to high       /*step through  zero ───► high. */
                                $=$ ||bar ||box.row.col /*build one cell at a time.     */
                                end   /*col*/           /* [↑]  build (row) line by cols*/
           say $ || bar; return                         /*finish building the last cell.*/
