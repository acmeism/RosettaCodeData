/*REXX program  produces and displays a    zig─zag  matrix   (a square array).          */
parse arg n start inc .                          /*obtain optional arguments from the CL*/
if     n=='' |     n==","  then     n= 5         /*Not specified?  Then use the default.*/
if start=='' | start==","  then start= 0         /* "      "         "   "   "     "    */
if   inc=='' |   inc==","  then   inc= 1         /* "      "         "   "   "     "    */
row= 1;           col= 1;        size= n**2      /*start: 1st row & column;  array size.*/
        do j=start  by inc  for size;    @.row.col= j
        if (row+col)//2==0  then do;  if col<n    then col= col+1;     else row= row+2
                                      if row\==1  then row= row-1
                                 end
                            else do;  if row<n    then row= row+1;     else col= col+2
                                      if col\==1  then col= col-1
                                 end
        end   /*j*/                              /* [↑]     //    is REXX  ÷  remainder.*/
call show                                        /*display a (square) matrix──►terminal.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: w= max(length(start), length(start+size*inc))  /*max width of any matrix elements,*/
        do   r=1  for n  ;  _=   right(@.r.1, w)     /*show the rows of the matrix.     */
          do c=2  for n-1;  _= _ right(@.r.c, w)     /*build a line for output of a row.*/
          end   /*c*/;  say _                        /* [↑]  align the matrix elements. */
        end     /*r*/;      return
