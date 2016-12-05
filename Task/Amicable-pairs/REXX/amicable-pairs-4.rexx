/*REXX program  calculates and displays all  amicable pairs  up to  a given number.     */
parse arg H .;   if H=='' | H==","  then H=20000 /*get optional arguments  (high limit).*/
w=length(H)  ;   low=220                         /*W: used for columnar output alignment*/
x=220 34765731 6232 87633 284 12285 10856 36939357 6368 5684679          /*S  minimums. */
   do i=0 for 10;  $.i=word(x,i+1);  end  /*i*/  /*minimum amicable #s for last dec dig.*/
#=0                                              /*number of amicable pairs found so far*/
@.=                                              /* [↑]  LOW is lowest amicable number. */
     do k=low  for H-low                         /*generate sigma sums for a range of #s*/
     parse var k  ''  -1  D                      /*obtain last decimal digit of   K.    */
     if k<$.D    then iterate                    /*if no need to compute, then skip it. */
         _=sigma(k)                              /*generate sigma sum for the number  K.*/
     @.k=_                                       /*only keep the pertinent sigma sums.  */
     if k==@._  then do                          /*is it a possible amicable number ?   */
                     if _==k  then iterate       /*Is it a perfect number?  Then skip it*/
                     #=#+1                       /*bump the amicable pair counter.      */
                     say right(_,w)     ' and '     right(k,w)    " are an amicable pair."
                     end
     end   /*k*/                                 /* [↑]   process a range of integers.  */
say
say #   'amicable pairs found up to'    H        /*display the count of amicable pairs. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
iSqrt: procedure; parse arg x;  r=0;  q=1;             do while q<=x;  q=q*4;  end
                  do while q>1; q=q%4; _=x-r-q; r=r%2; if _>=0 then do;x=_;r=r+q; end; end
       return r
/*──────────────────────────────────────────────────────────────────────────────────────*/
sigma: procedure; parse arg x;   od=x//2         /*use either  EVEN  or  ODD  integers. */
       s=1                                       /*set initial sigma sum to unity.   ___*/
                do j=2+od  by 1+od  to iSqrt(x)  /*divide by all integers up to the √ x */
                if x//j==0  then  s=s + j + x%j  /*add the two divisors to the sum.     */
                end   /*j*/                      /* [↑]  % is the REXX integer division.*/
       return s                                  /*return the sum of the divisors.      */
