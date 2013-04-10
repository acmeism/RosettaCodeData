/*REXX program is illustrate simple moving average. */
arg p q n .                               /*get some arguments (maybe). */
if p=='' then p=3                         /*the 1st period (default: 3).*/
if q=='' then q=5                         /* "  2nd   "        "     5  */
if n=='' then n=10                        /*number of items in the list.*/
a.=0
      do j=1 for n%2                      /*build beginning of the list,*/
      a.j=j                               /* ... increasing values.     */
      end   /*j*/

                 do k=n%2 to 1 by -1      /* ... decreasing values.     */
                 a.j=k
                 j=j+1
                 end   /*k*/

                          do i=1 for n    /*show an indented item list. */
                          say left('',60) 'item' right(i,3)'='right(a.i,3)
                          end   /*i*/
  do m=1 for n                            /*OK the, let's start the SMA.*/
  smaP=sma(p,m)                           /*simple moving average for P.*/
  smaQ=sma(q,m)                           /*  "      "       "     "  Q.*/

                                          /*show 2 nicely formated SMAs.*/
  say 'm='right(m,3),                     /*show where we're at in list.*/
      "   sma("p')='left(sma(p,m),11),    /*show nicely aligned sma P.  */
      "   sma("q')='left(sma(q,m),11)     /*  "    "       "     "  Q.  */
  end   /*m*/
exit
/*────────────────────────────────────────SMA subroutine────────────────*/
sma: procedure expose A.;   arg p,j;   s=0;   i=0
              do k=max(1,j-p+1)   to j+p   for p   while k<=j
              i=i+1
              s=s+a.k
              end
return s/i
