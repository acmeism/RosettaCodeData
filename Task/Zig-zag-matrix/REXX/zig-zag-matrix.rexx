/*REXX program to produce a  zig-zag  matrix  (array)  and display it.  */

parse arg n start inc .                /*get any and/or all arguments.  */
if     n==''   then     n=5            /*if not specified, use default. */
if start==''   then start=0            /* "  "      "       "     "     */
if   inc==''   then   inc=1            /* "  "      "       "     "     */
row=1;  col=1                          /*start with 1st row, 1st column.*/

  do j=start by inc for n*n;   @.row.col=j
  if (row+col)//2==0 then do
                          if col<n    then col=col+1
                                      else row=row+2
                          if row\==1  then row=row-1
                          end
                     else do
                          if row<n    then row=row+1
                                      else col=col+2
                          if col\==1  then col=col-1
                          end
  end   /*j*/

L=max(length(start),length(start+n*n*inc))  /*max length of any element.*/

  do row=1 for n;   _=                 /*show all the matrix's rows.    */
         do col=1 for n;    _=_ right(@.row.col,L);    end     /*col*/
  say _                                /*show the row just constructed. */
  end   /*row*/
                                       /*stick a fork in it, we're done.*/
