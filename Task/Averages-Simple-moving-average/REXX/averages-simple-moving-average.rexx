/*REXX program illustrates  simple moving average  using a simple list. */
parse arg p q n .                         /*get some arguments (maybe). */
if p==''  then p=3                        /*the 1st period (default: 3).*/
if q==''  then q=5                        /* "  2nd   "        "     5  */
if n==''  then n=10                       /*number of items in the list.*/
@.=0                                      /*define stemmed array, init 0*/
/*──────────────────────────────────────────build 1st half of the list. */
    do j=1  for n%2;       @.j=j;        end   /* ··· increasing values.*/
/*──────────────────────────────────────────build 2nd half of the list. */
    do k=n%2  to 1  by -1; @.j=k; j=j+1; end   /* ··· decreasing values.*/
/*──────────────────────────────────────────perform a simple moving avg.*/
say '          '         " SMA with "        ' SMA with '
say '  number  '         " period"  p' '     ' period'  q
say ' ──────── '         "──────────"        '──────────'
    do m=1  for n
    say center(@.m,10)   left(sma(p,m),11)   left(sma(q,m),11)
    end   /*m*/                        /* [↑]    show simple moving avg.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SMA subroutine──────────────────────*/
sma: procedure expose @.;       parse arg p,j;          s=0;     i=0
            do k=max(1,j-p+1)   to j+p   for p   while k<=j;     i=i+1
            s=s+@.k
            end   /*k*/
return s/i
