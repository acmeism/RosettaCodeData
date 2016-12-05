/*REXX program illustrates and displays a simple moving average using a constructed list*/
parse arg p q n .                                /*obtain optional arguments from the CL*/
if p=='' | p==","  then p= 3                     /*Not specified?  Then use the default.*/
if q=='' | q==","  then q= 5                     /* "      "         "   "   "     "    */
if n=='' | n==","  then n=10                     /* "      "         "   "   "     "    */
@.=0                                             /*default value, only needed for odd N.*/
     do j=1    for n%2;      @.j=j;         end  /*build 1st half of list, increasing #s*/
     do k=n%2  by -1  to 1;  @.j=k; j=j+1;  end  /*  "   2nd   "   "   "   decreasing " */

                      say '          '          " SMA with "             ' SMA with '
                      say '  number  '          " period"  p' '          ' period'  q
                      say ' ──────── '          "──────────"             '──────────'

     do m=1  for n;   say center(@.m, 10)  left(SMA(p, m), 11)  left(SMA(q, m), 11);   end
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
SMA: procedure expose @.;  parse arg p,j;                         i=0  ;   $=0
                 do k=max(1, j-p+1)  to j+p  for p  while k<=j;   i=i+1;   $=$+@.k;    end
     return $/i
