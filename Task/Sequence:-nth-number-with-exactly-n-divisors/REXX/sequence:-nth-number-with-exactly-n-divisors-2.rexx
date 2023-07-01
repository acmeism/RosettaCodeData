/*REXX program  finds and displays  the    Nth  number   with exactly   N   divisors.   */
parse arg N .                                    /*obtain optional argument from the CL.*/
if N=='' | N==","  then N= 15                    /*Not specified?  Then use the default.*/
if N>=50  then numeric digits 10                 /*use more decimal digits for large N. */
@.1= 2;               Ps= 1;    !.= 0;    !.1= 2 /*1st prime;  number of primes (so far)*/
        do p=3  until Ps==N**3                   /* [↓]  gen N primes, store in @ array.*/
        if \isPrime(p)  then iterate;     Ps= Ps + 1;    if Ps<=N  then  @.Ps= p;   !.p= 1
        end   /*p*/

zfin.= 0;    zcnt. = 0;  znum.1= 1;  znum.2= 3   /*completed;   index;   count of items.*/
w= 50                                            /*──────────handle odd primes──────────*/
     do j=3  by 2  to N;  if \!.j  then iterate  /*Not prime?  Then skip this odd number*/
     zfin.j= 1;   zcnt.j= j;   znum.j= pPow();   /*compute # divisors for this odd prime*/
     w= max(w, length( commas( znum.j) ) )       /*the last prime will be the biggest #.*/
     end   /*j*/                                 /*process a small number of primes ≤ N.*/
dd.=;                     mx= 200000             /*──────────handle odd non─primes──────*/
     do j=3  by 2  to N;  if !.j  then iterate   /*Is a prime?  Then skip this odd prime*/
        do sq=6;  _= sq*sq                       /*step through squares starting at  36.*/
        if dd._\=='' then d= dd._                /*maybe use a pre─computed # divisors. */
                     else d= #divs(_)            /*Not defined?  Then calculate # divs. */
        if _<=mx  then dd._= d                   /*use memoization for the  evens  loop.*/
        if d\==j  then iterate                   /*if not the right D, then skip this sq*/
        zcnt.d= zcnt.d+1;         if zcnt.d==d  then zfin.d= 1;        znum.d= _
        if zfin.d  then iterate j                /*if all were found,  then do next odd#*/
        end   /*sq*/
     end      /*j*/
                                                 /*──────────handle even numbers.───────*/
     do j=4  by 2; if dd.j\=='' then d= dd.j     /*maybe use a pre─computed # divisors. */
                                else d= #divs(j) /*Not defined?  Then calculate # divs. */
     if d>N       then iterate                   /*Divisors greater than N?  Then skip. */
     if zfin.d    then iterate                   /*Already populated?          "    "   */
                  else do; zcnt.d= zcnt.d+1;  if zcnt.d==d  then zfin.d= 1;  znum.d= j
                           if done()  then leave  /*j*/    /*Are the even #'s all done? */
                       end
     end       /*j*/

say '─divisors─'  center("the Nth number with exactly N divisors", w, '─')      /*title.*/
     do s=1  for N;  call tell  s,commas(znum.s) /*display  Nth  number with number divs*/
     end   /*s*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg _;  do c=length(_)-3  to 1  by -3; _=insert(',', _, c); end;    return _
done:      do f=N  by -1  for N-3;      if \zfin.f  then return 0;        end;    return 1
pPow:   numeric digits 2000;  return @.j**(j-1)  /*temporarily increase decimal digits. */
tell: parse arg _; say center(i,10) right(_,max(w,length(_))); if i//5==0 then say; return
/*──────────────────────────────────────────────────────────────────────────────────────*/
#divs: procedure; parse arg x 1 y                /*X and Y:  both set from 1st argument.*/
       if x<7  then do                           /*handle special cases for numbers < 7.*/
                    if x<3   then return x       /*   "      "      "    "  one and two.*/
                    if x<5   then return x - 1   /*   "      "      "    "  three & four*/
                    if x==5  then return 2       /*   "      "      "    "  five.       */
                    if x==6  then return 4       /*   "      "      "    "  six.        */
                    end
       odd= x // 2                               /*check if   X   is  odd  or not.      */
       if odd  then do;  #= 1;             end   /*Odd?   Assume  Pdivisors  count of 1.*/
               else do;  #= 3;    y= x%2;  end   /*Even?     "        "        "    " 3.*/
                                                 /* [↑]   start with known num of Pdivs.*/
                  do k=3  by 1+odd  while k<y    /*when doing odd numbers,  skip evens. */
                  if x//k==0  then do            /*if no remainder, then found a divisor*/
                                   #=#+2;  y=x%k /*bump  #  Pdivs,  calculate limit  Y. */
                                   if k>=y  then do;  #= #-1;  leave;  end      /*limit?*/
                                   end                                          /*  ___ */
                              else if k*k>x  then leave        /*only divide up to √ x  */
                  end   /*k*/                    /* [↑]  this form of DO loop is faster.*/
       return #+1                                /*bump "proper divisors" to "divisors".*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
isPrime: procedure; parse arg # . '' -1 _
         if #<31  then do;   if wordpos(#, '2 3 5 7 11 13 17 19 23 29')\==0  then return 1
                             if #<2  then return 0
                       end
         if #// 2==0 then return 0; if #// 3==0  then return 0; if     _==5  then return 0
         if #// 7==0 then return 0; if #//11==0  then return 0; if #//11==0  then return 0
         if #//13==0 then return 0; if #//17==0  then return 0; if #//19==0  then return 0
                               do i=23  by 6  until i*i>#;   if #// i   ==0  then return 0
                                                             if #//(i+2)==0  then return 0
                               end   /*i*/       /*           ___                       */
         return 1                                /*Exceeded  √ #  ?    Then # is prime. */
