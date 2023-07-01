/*REXX pgm calculates pisano period for a range of N, and pisanoPrime(N,m)  [for primes]*/
numeric digits 500                               /*ensure enough decimal digits for Fib.*/
parse arg lim.1 lim.2 lim.3 .                    /*obtain optional arguments from the CL*/
if lim.1=='' | lim.1==","  then lim.1=  15 - 1   /*Not specified?  Then use the default.*/
if lim.2=='' | lim.2==","  then lim.2= 180 - 1   /* "      "         "   "   "     "    */
if lim.3=='' | lim.3==","  then lim.3= 180       /* "      "         "   "   "     "    */
call Fib                                         /*    "      "   Fibonacci numbers.    */
         do i=1  for max(lim.1, lim.2, lim.3);  call pisano(i)    /*find pisano periods.*/
         end   /*i*/;    w= length(i)

    do j=1  for 2;  #= word(2 1, j)
       do p=1  for lim.j;  if \isPrime(p)  then iterate  /*Not prime?  Skip this number.*/
       say '   pisanoPrime('right(p, w)", "#') = 'right( pisanoPrime(p, #), 5)
       end   /*p*/;        say
    end      /*j*/

say center(' pisano numbers for 1──►'lim.3" ",  20*4 - 1,  "═")       /*display a title.*/
$=
    do j=1  for lim.3;     $= $  right(@.j, w)   /*append pisano number to the  $  list.*/
    if j//20==0  then do;  say substr($, 2);  $=;  end    /*display 20 numbers to a line*/
    end   /*j*/
                           say substr($, 2)      /*possible display any residuals──►term*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
fib: procedure expose fib.; parse arg x; fib.=.;     if x==''      then x= 1000
     fib.0= 0;  fib.1= 1;                            if fib.x\==.  then return fib.x
                  do k=2  for x-1;    a= k-1;        b= k-2;       fib.k=  fib.a + fib.b
                  end   /*k*/;    return fib.k
/*──────────────────────────────────────────────────────────────────────────────────────*/
isPrime: parse arg n; if n<11  then return pos(n, '2 3 5 7')>0;  if n//2==0  then return 0
            do k=3  by 2  while k*k<=n; if n//k==0  then return 0; end /*k*/;     return 1
/*──────────────────────────────────────────────────────────────────────────────────────*/
pisano: procedure expose @. fib.; parse arg m;   if m==1  then do;  @.m=1;  return 1;  end
                do k=1;  _= k+1;                 if fib.k//m==0 & fib._//m==1  then leave
                end   /*k*/;      @.m= k;                 return k
/*──────────────────────────────────────────────────────────────────────────────────────*/
pisanoPrime: procedure expose @. fib.; parse arg m,n;     return m**(n-1)  *  pisano(m)
