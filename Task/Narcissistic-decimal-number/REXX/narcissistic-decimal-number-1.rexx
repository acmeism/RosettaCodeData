/*REXX program  generates and displays  a number of  narcissistic (Armstrong)  numbers. */
numeric digits 39                                /*be able to handle largest Armstrong #*/
parse arg N .                                    /*obtain optional argument from the CL.*/
if N=='' | N==","  then N=25                     /*Not specified?  Then use the default.*/
N=min(N, 89)                                     /*there are only  89  narcissistic #s. */
#=0                                              /*number of narcissistic numbers so far*/
     do j=0  until #==N;     L=length(j)         /*get length of the  J  decimal number.*/
     $=left(j, 1) **L                            /*1st digit in  J  raised to the L pow.*/

               do k=2  for L-1  until $>j        /*perform for each decimal digit in  J.*/
               $=$ + substr(j, k, 1) ** L        /*add digit raised to power to the sum.*/
               end   /*k*/                       /* [↑]  calculate the rest of the sum. */

     if $\==j  then iterate                      /*does the sum equal to J?  No, skip it*/
     #=# + 1                                     /*bump count of narcissistic numbers.  */
     say right(#, 9)     ' narcissistic:'     j  /*display index and narcissistic number*/
     end   /*j*/                                 /*stick a fork in it,  we're all done. */
