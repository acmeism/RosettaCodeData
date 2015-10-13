/*REXX program finds and displays all  amicable pairs  up to  a given number. */
parse arg H .; if H==''  then H=20000  /*get optional arguments  (high limit).*/
w=length(H)  ; low=220                 /*W: used for columnar output alignment*/
x=220 34765731 6232 87633 284 12285 10856 36939357 6368 5684679  /*S minimums.*/
y=220 34765731 6232 69615 220 12285 10744 34765731 6232 5357625  /*D minimums.*/
   do i=0 for 10; $.i=word(x,i+1); L.i=word(y,i+1); end /*minimum amicable #s.*/
#=0                                    /*number of amicable pairs found so far*/
@.=                                    /* [↑]  LOW is lowest amicable number. */
     do k=low  for H-low               /*generate sigma sums for a range of #s*/
     parse var k  ''  -1  D            /*obtain last decimal digit of   K.    */
     if k<$.D    then iterate          /*if no need to compute, then skip it. */
        _=sigma(k)                     /*generate sigma sum for the number  K.*/
     if _<L.D    then iterate          /*if sigma sum is too low, then skip it*/
     @.k=_                             /*only keep the pertinent sigma sums.  */
     if k==@._  then do                       /*is it a possible amicable # ? */
                     if _==k  then iterate    /*ignore any perfect numbers.   */
                     #=#+1                    /*bump the amicable pair counter*/
                     say right(_,w) ' and ' right(k,w)  " are an amicable pair."
                     end
     end   /*k*/                       /* [↑]   process a range of integers.  */
say
say # 'amicable pairs found up to'  H  /*display the count of amicable pairs. */
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
iSqrt: procedure; parse arg x;  r=0;  q=1;           do while q<=x;  q=q*4;  end
         do while q>1; q=q%4; _=x-r-q; r=r%2; if _>=0 then do;x=_;r=r+q; end;end
       return r
/*────────────────────────────────────────────────────────────────────────────*/
sigma: procedure; parse arg x; od=x//2 /*use either  EVEN  or  ODD  integers. */
s=1                                    /*set initial sigma sum to unity.   ___*/
      do j=2+od  by 1+od  to iSqrt(x)  /*divide by all integers up to the √ x */
      if x//j==0  then  s=s + j + x%j  /*add the two divisors to the sum.     */
      end   /*j*/                      /* [↑]  %  is REXX integer division.   */
return s                               /*return the sum of the divisors.      */
