/*REXX program  finds and displays  N   weird numbers in a vertical format (with index).*/
parse arg n cols .                               /*obtain optional arguments from the CL*/
if    n=='' |    n==","  then    n= 25           /*Not specified?  Then use the default.*/
if cols=='' | cols==","  then cols= 10           /* "      "         "   "   "     "    */
w= 10                                            /*width of a number in any column.     */
if cols>0 then say ' index │'center(' weird numbers',   1 + cols*(w+1)     )
if cols>0 then say '───────┼'center(""              ,   1 + cols*(w+1), '─')
idx= 1;                          $=              /*index for the output list;  $: 1 line*/
weirds= 0                                        /*the count of weird numbers  (so far).*/
     do j=2  by 2  until weirds==n               /*examine even integers 'til have 'nuff*/
     if \weird(j)  then iterate                  /*Not a  weird  number?  Then skip it. */
     weirds= weirds + 1                          /*bump the count of  weird   numbers.  */
     c= commas(j)                                /*maybe add commas to the number.      */
     $= $ right(c, max(w, length(c) ) )          /*add a nice prime ──► list, allow big#*/
     if weirds//cols\==0  then iterate           /*have we populated a line of output?  */
     say center(idx, 7)'│'  substr($, 2);   $=   /*display what we have so far  (cols). */
     idx= idx + cols                             /*bump the  index  count for the output*/
     end   /*j*/

if $\==''  then say center(idx, 7)"│"  substr($, 2)  /*possible display residual output.*/
if cols>0 then say '───────┴'center(""    ,  1 + cols*(w+1), '─')
say
say 'Found '       commas(weirds)          ' weird numbers'
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg _;  do ic=length(_)-3  to 1  by -3; _=insert(',', _, ic); end;  return _
/*──────────────────────────────────────────────────────────────────────────────────────*/
DaS:  procedure; parse arg x 1 z 1,b;       a= 1 /*get X,Z,B (the 1st arg); init A list.*/
      r= 0;         q= 1                         /* [↓] ══integer square root══     ___ */
           do while q<=z; q=q*4; end             /*R:  an integer which will be    √ X  */
           do while q>1;  q=q%4;  _= z-r-q;  r=r%2;  if _>=0  then  do;  z=_;  r=r+q;  end
           end   /*while q>1*/                   /* [↑]  compute the integer sqrt of  X.*/
      sig= a                                     /*initialize the sigma so far.     ___ */
          do j=2  to r - (r*r==x)                /*divide by some integers up to   √ X  */
          if x//j==0  then do;  a=a j;  b= x%j b /*if ÷, add both divisors to  α and ß. */
                                sig= sig +j +x%j /*bump the sigma (the sum of divisors).*/
                           end
          end   /*j*/                            /* [↑]  %  is the REXX integer division*/
                                                 /* [↓]  adjust for a square.        ___*/
      if j*j==x  then  return sig+j   a j b      /*Was  X  a square?    If so, add  √ X */
                       return sig     a   b      /*return the divisors  (both lists).   */
/*──────────────────────────────────────────────────────────────────────────────────────*/
weird: procedure; parse arg x .                  /*obtain a # to be tested for weirdness*/
       if x<70 | x//3==0   then return 0         /*test if X is too low or multiple of 3*/
       parse value  DaS(x)  with  sigma divs     /*obtain sigma and the proper divisors.*/
       if sigma<=x  then  return 0               /*X  isn't abundant  (sigma too small).*/
       #= words(divs)                            /*count the number of divisors for  X. */
       if #<3   then return 0                    /*Not enough divisors?    "      "     */
       if #>15  then return 0                    /*number of divs > 15?  It's not weird.*/
       a.=                                       /*initialize the    A.   stemmed array.*/
           do i=1  for #;     _= word(divs, i)   /*obtain one of the divisors of  X.    */
           @.i= _;          a._= .               /*assign proper divs──►@ array; also id*/
           end   /*i*/
       df= sigma - x                             /*calculate difference between Σ and X.*/
       if a.df==.  then return 0                 /*Any divisor is equal to DF? Not weird*/
       c= 0                                      /*zero combo counter; calc. power of 2.*/
           do p=1  for 2**#-2;         c= c + 1  /*convert P──►binary with leading zeros*/
           yy.c= strip( x2b( d2x(p) ),  'L', 0)  /*store this particular combination.   */
           end   /*p*/
                                                 /* [↓]  decreasing partitions is faster*/
           do part=c  by -1  for c;      s= 0    /*test of a partition add to the arg X.*/
           _= yy.part;           L= length(_)    /*obtain one method of partitioning.   */
             do cp=L  by -1  for L               /*obtain a sum of  a  partition.       */
             if substr(_,cp,1)  then do;  s= s + @.cp            /*1 bit?  Then add ──►S*/
                                          if s==x  then return 0 /*Sum equal?  Not weird*/
                                          if s==df then return 0 /*Sum = DF?    "    "  */
                                          if s>x   then iterate  /*Sum too big? Try next*/
                                     end
             end   /*cp*/
           end   /*part*/;           return 1    /*no sum equal to  X,  so  X  is weird.*/
