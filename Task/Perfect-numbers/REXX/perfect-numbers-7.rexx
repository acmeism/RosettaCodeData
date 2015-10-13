/*REXX program tests if a number (or a range of numbers) is/are perfect.*/
parse arg low high .                   /*obtain the specified number(s).*/
if high=='' & low==''  then high=34000000     /*if no args, use a range.*/
if  low==''            then  low=1     /*if no   LOW, then assume unity.*/
low=low+low//2                         /*if LOW is odd,  bump it by one.*/
if high==''            then high=low   /*if no  HIGH, then assume  LOW. */
w=length(high)                         /*use  W  for formatting output. */
numeric digits max(9,w+2)              /*ensure enough digits to handle#*/
@. =0;    @.1=2;     !.=2;     _=' 6'  /*highest magic #  and its index.*/
!._=22;   !.16=12;   !.28=8;   !.36=20;   !.56=20;   !.76=20;   !.96=20
                                       /* [↑]   "Lucas' numbers,  1891. */
               do i=low  to high  by 0 /*process the single # or range. */
               if isPerfect(i)  then say right(i,w) 'is a perfect number.'
               i=i+!.?                 /*use a fast advance for DO loop.*/
               end   /*i*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ISPERFECT subroutine────────────────*/
isPerfect: procedure expose @. !. ?    /*expose (make global) some vars.*/
parse arg x 1 y '' -2 ?                /*#, another copy, and last digit*/
if x==6    then return 1               /*handle special case of  six.   */
if !.?==2  then return 0               /*test last 2digs: François Lucas*/
                                       /*Lucas-Lehmer know that perfect */
                                       /*  numbers can be expressed as: */
                                       /*  [2**n - 1]  *  [2** (n-1) ]  */

if @.0<x then do @.1=@.1 while @._<=x; _=(2**@.1-1)*2**(@.1-1); @.0=_; @._=_
              end   /*@.1*/            /*uses memoization for formula.  */

if @.x==0  then return 0               /*Didn't pass Lucas-Lehmer test? */
                                       /*[↓] perfect #s digitalRoot = 1.*/
      do  until  y<10                  /*find the digital root of  Y.   */
      parse var y r 2;  do k=2  for length(y)-1;  r=r+substr(y,k,1);   end
      y=r                              /*find digital root of dig root. */
      end   /*until*/                  /*wash, rinse, repeat ···        */

if r\==1  then return 0                /*Digital root ¬1? Then ¬perfect.*/
s = 3 + x%2                            /*we know the following factors: */
                                       /*  1      ('cause Mama said so.)*/
                                       /*  2      ('cause it's even.)   */
                                       /* x÷2     (   "     "    "  )  _*/
             do j=3  while  j*j<=x     /*starting at 3, find factors ≤√X*/
             if x//j\==0  then iterate /*J  divides  X  evenly,  so ... */
             s = s + j + x%j           /*··· add it and the other factor*/
             if s>x  then return 0     /*Sum too big?  It ain't perfect.*/
             end   /*j*/               /*(above)  is marginally faster. */
return s==x                            /*if the sum matches X, perfect! */
