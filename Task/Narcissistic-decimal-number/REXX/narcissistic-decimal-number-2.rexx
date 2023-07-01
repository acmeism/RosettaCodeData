/*REXX program  generates and displays  a number of  narcissistic (Armstrong)  numbers. */
numeric digits 39                                /*be able to handle largest Armstrong #*/
parse arg N .                                    /*obtain optional argument from the CL.*/
if N=='' | N==","  then N=25                     /*Not specified?  Then use the default.*/
N=min(N, 89)                                     /*there are only  89  narcissistic #s. */

     do     p=1  for 39                          /*generate tables:   digits ^ P power. */
         do i=0  for 10;      @.p.i= i**p        /*build table of ten digits ^ P power. */
         end   /*i*/
     end       /*w*/                             /* [↑]  table is a fixed (limited) size*/
#=0                                              /*number of narcissistic numbers so far*/
     do j=0  until #==N;      L=length(j)        /*get length of the  J  decimal number.*/
     _=left(j, 1)                                /*select the first decimal digit to sum*/
     $=@.L._                                     /*sum of the J dec. digits ^ L (so far)*/
               do k=2  for L-1  until $>j        /*perform for each decimal digit in  J.*/
               _=substr(j, k, 1)                 /*select the next decimal digit to sum.*/
               $=$ + @.L._                       /*add dec. digit raised to power to sum*/
               end   /*k*/                       /* [↑]  calculate the rest of the sum. */

     if $\==j  then iterate                      /*does the sum equal to J?  No, skip it*/
     #=# + 1                                     /*bump count of narcissistic numbers.  */
     say right(#, 9)     ' narcissistic:'     j  /*display index and narcissistic number*/
     end   /*j*/                                 /*stick a fork in it,  we're all done. */
