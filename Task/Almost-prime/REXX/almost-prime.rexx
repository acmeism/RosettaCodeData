/*REXX program  computes and displays  the  first  N  K─almost  primes  from   1 ── ►K. */
parse arg N K .                                  /*get optional arguments from the C.L. */
if N=='' | N==","  then N=10                     /*N  not specified?   Then use default.*/
if K=='' | K==","  then K= 5                     /*K   "      "          "   "     "    */
                                                 /*W: is the width of K, used for output*/
    do m=1  for  K;     $=2**m;  fir=$           /*generate & assign 1st K─almost prime.*/
    #=1;                if #==N  then leave      /*#: K─almost primes; Enough are found?*/
    #=2;                $=$  3*(2**(m-1))        /*generate & append 2nd K─almost prime.*/
    if #==N  then leave                          /*#: K─almost primes; Enough are found?*/
    if m==1  then _=fir+fir                      /* [↓]  gen & append 3rd K─almost prime*/
             else do;  _=9*(2**(m-2));    #=3;   $=$  _;    end
        do j=_+m-1  until #==N                   /*process an  K─almost prime  N  times.*/
        if #factr()\==m  then iterate            /*not the correct  K─almost  prime?    */
        #=#+1;   $=$ j                           /*bump K─almost counter; append it to $*/
        end   /*j*/                              /* [↑]   generate  N  K─almost  primes.*/
    say right(m, length(K))"─almost ("N') primes:'     $
    end       /*m*/                              /* [↑]  display a line for each K─prime*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
#factr:  z=j;                  do f=0  while z//2==0;  z=z%2;  end    /*divisible by 2. */
                               do f=f  while z//3==0;  z=z%3;  end    /*divisible  " 3. */
                               do f=f  while z//5==0;  z=z%5;  end    /*divisible  " 5. */
                               do f=f  while z//7==0;  z=z%7;  end    /*divisible  " 7. */
  do i=11  by 6  while  i<=z                     /*insure  I  isn't divisible by three. */
  parse var  i   ''  -1  _                       /*obtain the right─most decimal digit. */
                                                 /* [↓]  fast check for divisible by 5. */
  if _\==5  then do; do f=f+1  while z//i==0; z=z%i; end;  f=f-1; end /*divisible by I. */
  if _==3  then iterate                          /*fast check for  X  divisible by five.*/
  x=i+2;             do f=f+1  while z//x==0; z=z%x; end;  f=f-1      /*divisible by X. */
  end   /*i*/                                    /* [↑]  find all the factors in  Z.    */

return max(f, 1)                                 /*if  prime (f==0),  then return unity.*/
