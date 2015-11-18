/*REXX program produces and displays a    zig─zag  matrix   (a square array). */
parse arg n start inc .                /*obtain optional arguments from the CL*/
if     n==''   then     n=5            /*Not specified?  Then use the default.*/
if start==''   then start=0            /* "      "         "   "   "     "    */
if   inc==''   then   inc=1            /* "      "         "   "   "     "    */
row=1;     col=1                       /*start with the  1st row,  1st column.*/
size=n**2                                                     /*size of array.*/
           do j=start  by inc  for size;    @.row.col=j
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

w=max(length(start), length(start+size*inc))   /*maximum width of any element.*/

  do       row=1  for n;   _=          /*show all the rows of the matrix.     */
        do col=1  for n;   _=_ right(@.row.col,w);    end  /*col*/
  say _                                /*show the matrix row just constructed.*/
  end   /*row*/                        /*stick a fork in it,  we're all done. */
