/*REXX program tests if a number (or a range of numbers) is/are perfect.*/
parse arg low high .                   /*obtain the specified number(s).*/
if high=='' & low=='' then high=34000000      /*if no args, use a range.*/
if  low=='' then  low=1                /*if no   LOW, then assume unity.*/
if high=='' then high=low              /*if no  HIGH, then assume  LOW. */
w=length(high)                         /*use  W  for formatting output. */
numeric digits max(9,w+2)              /*ensure enough digits to handle#*/
@.=0;   @.1=2                          /*highest magic #  and its index.*/
                do i=low to high       /*process the single # or range. */
                if isperfect(i) then say right(i,w) 'is a perfect number.'
                end   /*i*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ISPERFECT subroutine────────────────*/
isperfect: procedure expose @.; parse arg x    /*get the # to be tested.*/
if x//2==1 then return 0               /*if it's an odd number, it ain't*/
                                       /*Lucas-Lehmer know that perfect */
                                       /*  numbers can be expressed as: */
                                       /*  [2**n - 1]  *  [2** (n-1) ]  */

if @.0<x then do @.1=@.1 while @._<=x; _=(2**@.1-1)*2**(@.1-1); @.0=_; @._=_
              end   /*@.1*/            /*uses memoization for formula.  */

if @.x==0 then return 0                /*Didn't pass Lucas-Lehmer test? */
sum=3+x%2                              /*we know the following factors: */
                                       /*  1      ('cause Mama said so.)*/
                                       /*  2      ('cause it's even.)   */
                                       /* x÷2         "     "    "      */
              do j=3 while j*j<=x      /*starting at 3, find factors ≤√X*/
              if x//j\==0 then iterate /*J  divides  X  evenly,  so ... */
              sum=sum+j+x%j            /*... add it and the other factor*/
              if sum>x then return 0   /*Sum too big?  It ain't perfect.*/
              end   /*j*/              /*(above)  is marginally faster. */
return sum==x                          /*if the sum matches X, perfect! */
