/*REXX program to compute and display  (unsigned)  Stirling numbers   of the first kind.*/
parse arg lim .                                  /*obtain optional argument from the CL.*/
if lim=='' | lim==","  then lim= 12              /*Not specified?  Then use the default.*/
olim= lim                                        /*save     the original value of  LIM. */
lim= abs(lim)                                    /*only use the absolute value of  LIM. */
numeric digits max(9, 2*lim)                     /*(over) specify maximum number in grid*/
@.=;                                 @.0.0= 1    /*define the   (0, 0)th  value  in grid*/
        do n=0  for lim+1                        /* [↓]  initialize some  values  "   " */
        if n>0  then @.n.0 = 0                   /*assign value if  N > zero.           */
          do k=n+1  to lim
          @.n.k = 0                              /*zero some values in grid  if  K > N. */
          end   /*k*/
        end     /*n*/
max#.= 0                                         /* [↓]  calculate values for the grid. */
        do   n=1  for lim;           nm= n - 1
          do k=1  for lim;           km= k - 1
          @.n.k = @.nm.km  +  nm * @.nm.k        /*calculate an unsigned number in grid.*/
          max#.k= max(max#.k, @.n.k)             /*find the      maximum value   "   "  */
          max#.b= max(max#.b, @.n.k)             /*find the maximum value for all rows. */
          end   /*k*/
        end     /*n*/

        do k=1  for lim                          /*find max column width for each column*/
        max#.a= max#.a + length(max#.k)
        end   /*k*/
                                                 /* [↓]  only show the maximum value ?  */
w= length(max#.b)                                /*calculate max width of all numbers.  */
if olim<0  then do;  say 'The maximum value  (which has '      w      " decimal digits):"
                     say max#.b                  /*display maximum number in the grid.  */
                     exit                        /*stick a fork in it,  we're all done. */
                end
wi= max(3, length(lim+1) )                       /*the maximum width of the grid's index*/
say 'row'  center('columns', max(9, max#.a + lim), '═')    /*display header of the grid.*/

        do r=0  for lim+1;   $=                  /* [↓]  display the grid to the term.  */
          do c=0  for lim+1  until c>=r          /*build a row of grid, 1 col at a time.*/
          $= $  right(@.r.c, length(max#.c) )    /*append a column to a row of the grid.*/
          end   /*c*/
        say right(r,wi)  strip(substr($,2), 'T') /*display a single row of the grid.    */
        end     /*r*/                            /*stick a fork in it,  we're all done. */
