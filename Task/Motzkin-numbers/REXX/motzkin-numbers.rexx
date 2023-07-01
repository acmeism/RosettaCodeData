/*REXX program to display the first  N  Motzkin numbers,  and if that number is prime.  */
numeric digits 92                                /*max number of decimal digits for task*/
parse arg n .                                    /*obtain optional argument from the CL.*/
if n=='' | n==","  then n= 42                    /*Not specified?  Then use the default.*/
w= length(n) + 1;  wm= digits()%4                /*define maximum widths for two columns*/
say center('n', w     )   center("Motzkin[n]", wm)       center(' primality', 11)
say center('' , w, "─")   center(''          , wm, "─")  center('',           11, "─")
@.= 1                                            /*define default vale for the @. array.*/
      do m=0  for n                              /*step through indices for Motzkin #'s.*/
      if m>1  then @.m= (@(m-1)*(m+m+1) + @(m-2)*(m*3-3))%(m+2)  /*calculate a Motzkin #*/
      call show                                  /*display a Motzkin number ──► terminal*/
      end   /*m*/

say center('' , w, "─")   center(''          , wm, "─")  center('',           11, "─")
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
@:      parse arg i;          return @.i         /*return function expression based on I*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end; return ?
prime:  if isPrime(@.m)  then return "   prime";                                 return ''
show:   y= commas(@.m);  say right(m, w)  right(y, max(wm, length(y)))  prime(); return
/*──────────────────────────────────────────────────────────────────────────────────────*/
isPrime: procedure expose p?. p#. p_.;  parse arg x     /*persistent P·· REXX variables.*/
         if symbol('P?.#')\=='VAR'  then         /*1st time here?   Then define primes. */
           do                                    /*L is a list of some low primes < 100.*/
           L= 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101
           p?.=0                                 /* [↓]  define P_index,  P,  P squared.*/
                  do i=1  for words(L);   _= word(L,i);   p?._= 1;   p#.i= _;   p_.i= _*_
                  end   /*i*/;                   p?.0= x2d(3632c8eb5af3b) /*bypass big ÷*/
           p?.n= _ + 4                           /*define next prime after last prime.  */
           p?.#= i - 1                           /*define the number of primes found.   */
           end                                   /* p?.  p#.  p_   must be unique.      */
         if x<p?.n  then return p?.x             /*special case, handle some low primes.*/
         if x==p?.0 then return 1                /*save a number of primality divisions.*/
         parse var  x   ''   -1   _              /*obtain right─most decimal digit of X.*/
         if    _==5  then return 0;  if x//2 ==0  then return 0   /*X ÷ by 5?  X ÷ by 2?*/
         if x//3==0  then return 0;  if x//7 ==0  then return 0   /*" "  " 3?  " "  " 7?*/
                                                 /*weed numbers that're ≥ 11 multiples. */
           do j=5  to p?.#  while p_.j<=x;  if x//p#.j ==0  then return 0
           end   /*j*/
                                                 /*weed numbers that're>high multiple Ps*/
           do k=p?.n  by 6  while k*k<=x;   if x//k    ==0  then return 0
                                            if x//(k+2)==0  then return 0
           end   /*k*/;           return 1       /*Passed all divisions?   It's a prime.*/
