/*REXX program  generates and displays  a number of  narcissistic (Armstrong)  numbers. */
numeric digits 39                                /*be able to handle largest Armstrong #*/
parse arg N .                                    /*obtain optional argument from the CL.*/
if N=='' | N==","  then N=25                     /*Not specified?  Then use the default.*/
N=min(N, 89)                                     /*there are only  89  narcissistic #s. */
@.=0                                             /*set default for the @ stemmed array. */
#=0                                              /*number of narcissistic numbers so far*/
     do p=0  for 39+1; if p<10  then call tell p /*display the 1st 1─digit dec. numbers.*/
         do i=1  for 9;      @.p.i= i**p         /*build table of ten digits ^ P power. */
         zzj= '00'j;       @.p.zzj= @.p.j        /*assign value for a 3-dig number (LZ),*/
         end   /*i*/

         do j=10  to 99;   parse var j  t 2 u    /*obtain 2 decimal digits of J:    T U */
         @.p.j = @.p.t + @.p.u                   /*assign value for a 2─dig number.     */
         zj=  '0'j;        @.p.zj = @.p.j        /*   "     "    "  " 3─dig    "   (LZ),*/
         end   /*j*/                             /* [↑]  T≡ tens digit;  U≡ units digit.*/

         do k=100  to 999; parse var k h 2 t 3 u /*obtain 3 decimal digits of J:  H T U */
         @.p.k= @.p.h + @.p.t + @.p.u            /*assign value for a three-digit number*/
         end   /*k*/                             /* [↑]  H≡ hundreds digit;  T≡ tens ···*/
     end       /*p*/                             /* [↑]  table is a fixed (limited) size*/
                                                 /* [↓]  skip the 2─digit dec. numbers. */
     do j=100;               L=length(j)         /*get length of the  J  decimal number.*/
     parse var  j  _  +3  m                      /*get 1st three decimal digits of  J.  */
     $=@.L._                                     /*sum of the J decimal digs^L (so far).*/
                do  while m\==''                 /*do the rest of the dec. digs in  J.  */
                parse var  m    _  +3  m         /*get the next 3 decimal digits in  M. */
                $=$ + @.L._                      /*add dec. digit raised to pow to sum. */
                end   /*while*/                  /* [↑]  calculate the rest of the sum. */

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
