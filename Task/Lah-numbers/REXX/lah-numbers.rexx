/*REXX pgm computes & display (unsigned) Stirling numbers of the 3rd kind (Lah numbers).*/
parse arg lim .                                  /*obtain optional argument from the CL.*/
if lim=='' | lim==","  then lim= 12              /*Not specified?  Then use the default.*/
olim= lim                                        /*save     the original value of  LIM. */
lim= abs(lim)                                    /*only use the absolute value of  LIM. */
numeric digits max(9, 4*lim)                     /*(over) specify maximum number in grid*/
max#.= 0
!.=.
@.=                                              /* [↓]  calculate values for the grid. */
        do   n=0  to  lim;   nm= n - 1
          do k=0  to  lim;   km= k - 1
          if k==1               then do;  @.n.k= !(n); call maxer; iterate;  end
          if k==n               then do;  @.n.k= 1   ;             iterate;  end
          if k>n | k==0 | n==0  then do;  @.n.k= 0   ;             iterate;  end
          @.n.k = (!(n) * !(nm)) % (!(k) * !(km)) % !(n-k)  /*calculate a # in the grid.*/
          call maxer                                        /*find    max #  "  "    "  */
          end   /*k*/
        end     /*n*/

        do k=0  for lim+1                        /*find max column width for each column*/
        max#.a= max#.a + length(max#.k)
        end   /*k*/
                                                 /* [↓]  only show the maximum value ?  */
w= length(max#.b)                                /*calculate max width of all numbers.  */
if olim<0  then do;  say 'The maximum value  (which has '      w      " decimal digits):"
                     say max#.b                  /*display maximum number in the grid.  */
                     exit                        /*stick a fork in it,  we're all done. */
                end                              /* [↑]  the 100th row is when LIM is 99*/
wi= max(3, length(lim+1) )                       /*the maximum width of the grid's index*/
say 'row'  center('columns', max(9, max#.a + lim), '═')    /*display header of the grid.*/

        do r=0  for lim+1;   $=                  /* [↓]  display the grid to the term.  */
          do c=0  for lim+1  until c>=r          /*build a row of grid, 1 col at a time.*/
          $= $  right(@.r.c, length(max#.c) )    /*append a column to a row of the grid.*/
          end   /*c*/
        say right(r,wi)  strip(substr($,2), 'T') /*display a single row of the grid.    */
        end     /*r*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
!: parse arg z; if !.z\==. then return !.z; !=1; do f=2  to z; !=!*f; end; !.z=!; return !
maxer:   max#.k= max(max#.k, @.n.k);        max#.b= max(max#.b, @.n.k);           return
