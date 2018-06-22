/*REXX program  generates and displays  a number of  narcissistic (Armstrong)  numbers. */
numeric digits 39                                /*be able to handle largest Armstrong #*/
parse arg N .                                    /*obtain optional argument from the CL.*/
if N=='' | N==","  then N=25                     /*Not specified?  Then use the default.*/
N=min(N, 89)                                     /*there are only  89  narcissistic #s. */
@.=0                                             /*set default for the @ stemmed array. */
#=0                                              /*number of narcissistic numbers so far*/
     do p=0  for 39+1; if p<10  then call tell p /*display the 1st 1─digit dec. numbers.*/
         do i=1  for 9;     @.p.i= i**p          /*build table of ten digits ^ P power. */
         end   /*i*/
     end       /*p*/                             /* [↑]  table is a fixed (limited) size*/
                                                 /* [↓]  skip the 2─digit dec. numbers. */
     do j=100;              L=length(j)          /*get length of the  J  decimal number.*/
     parse var  j    _1  2  _2  3  m  ''  -1  _R /*get 1st, 2nd, middle, last dec. digit*/
     $=@.L._1  +  @.L._2  +  @.L._R              /*sum of the J decimal digs^L (so far).*/

              do k=3  for L-3  until $>j         /*perform for other decimal digits in J*/
              parse var  m    _  +1  m           /*get next dec. dig in J, start at 3rd.*/
              $=$ + @.L._                        /*add dec. digit raised to pow to sum. */
              end   /*k*/                        /* [↑]  calculate the rest of the sum. */

     if $==j  then do;  call tell j              /*does the sum equal to  J?  Show the #*/
                        if #==n  then leave      /*does the sum equal to  J?  Show the #*/
                   end
     end   /*j*/                                 /* [↑]  the  J loop  list starts at 100*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
tell: #=# + 1                                    /*bump the counter for narcissistic #s.*/
      say right(#,9)   ' narcissistic:'   arg(1) /*display index and narcissistic number*/
      if #==n  &  n<11  then exit                /*finished showing of narcissistic #'s?*/
      return                                     /*return to invoker & keep on truckin'.*/
