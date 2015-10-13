/*REXX program illustrates  simple moving average  using a constructed list.  */
parse arg p q n .                      /*get optional arguments from the C.L. */
if p==''  then p=3                     /*the 1st period  (the default is:  3).*/
if q==''  then q=5                     /* "  2nd   "       "     "     "   5).*/
if n==''  then n=10                    /*the number of items in the list.     */
@.=0                                   /*define array with initial zero values*/
                                                /* [↓]  build 1st half of list*/
    do j=1  for n%2;       @.j=j;        end    /*      ··· increasing values.*/
                                                /* [↓]  build 2nd half of list*/
    do k=n%2  to 1  by -1; @.j=k; j=j+1; end    /*      ··· decreasing values.*/

say '          '         " SMA with "        ' SMA with '
say '  number  '         " period"  p' '     ' period'  q
say ' ──────── '         "──────────"        '──────────'

                                       /* [↓]  perform a simple moving average*/
            do m=1  for n
            say center(@.m, 10)       left(sma(p,m), 11)      left(sma(q,m), 11)
            end   /*m*/                /* [↑]    show a simple moving average.*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
sma: procedure expose @.;          parse arg p,j;          s=0;     i=0
               do k=max(1,j-p+1)   to j+p   for p   while k<=j;     i=i+1
               s=s+@.k
               end   /*k*/
return s/i
