/*REXX program to compute and display   Stirling numbers   of the second kind.          */
parse arg lim .                                  /*obtain optional argument from the CL.*/
if lim=='' | lim==","  then lim= 12              /*Not specified?  Then use the default.*/
olim= lim                                        /*save     the original value of  LIM. */
lim= abs(lim)                                    /*only use the absolute value of  LIM. */
numeric digits max(9, 2*lim)                     /*(over) specify maximum number in grid*/
@.=
             do j=0  for lim+1
             @.j.j = 1;  if j==0  then iterate   /*define the right descending diagonal.*/
             @.0.j = 0;  @.j.0 = 0               /*   "    "  zero  values.             */
             end   /*j*/
max#.= 0                                         /* [↓]  calculate values for the grid. */
          do   n=0  for lim+1;         np= n + 1
            do k=1  for lim;           km= k - 1
            @.np.k = k * @.n.k  +  @.n.km        /*calculate a number in the grid.      */
            max#.k= max(max#.k, @.n.k)           /*find the maximum value for a column. */
            max#.b= max(max#.b, @.n.k)           /*find the maximum value for all rows. */
            end   /*k*/
          end     /*n*/
                                                 /* [↓]  only show the maximum value ?  */
        do k=0  for lim+1                        /*find max column width for each column*/
        max#.a= max#.a + length(max#.k)
        end   /*k*/

w= length(max#.b)                                /*calculate max width of all numbers.  */
if olim<0  then do;  say 'The maximum value  (which has '       w      " decimal digits):"
                     say max#.b                  /*display maximum number in the grid.  */
                     exit                        /*stick a fork in it,  we're all done. */
                end
wgi= max(5, length(lim+1) )                      /*the maximum width of the grid's index*/
say '═row═'  center("columns", max(9, max#.a + lim), '═')  /*display header of the grid.*/

    do   r=0  for lim+1;        $=               /* [↓]  display the grid to the term.  */
      do c=0  for lim+1  until c>=r              /*build a row of grid, 1 col at a time.*/
      $= $  right(@.r.c, length(max#.c) )        /*append a column to a row of the grid.*/
      end   /*c*/
    say center(r, wgi)  strip( substr($,2), 'T') /*display a single row of the grid.    */
    end     /*r*/                                /*stick a fork in it,  we're all done. */
