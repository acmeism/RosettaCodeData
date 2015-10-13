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
     if k<$.D     then iterate         /*if no need to compute, then skip it. */
     od=k//2                           /*OD:   set to  unity  if   K   is odd.*/
     z=k;  r=0;  q=1;      do while q<=z;  q=q*4;  end  /*R will be iSqrt of Z*/
         do while q>1; q=q%4; _=z-r-q; r=r%2; if _>=0 then do;z=_;r=r+q; end;end
     s=1                               /*set initial sigma sum to unity.   ___*/
         do j=2+od  by 1+od   to r     /*divide by all integers up to the √ K */
         if k//j==0  then s=s+ j + k%j /*add the two divisors to the sum.     */
         end   /*j*/                   /* [↑]  %  is REXX integer division.   */
     if s<L.D     then iterate         /*if sigma sum is too low, then skip it*/
     if od\==s//2 then iterate         /*if both don't have same parity, skip.*/
     @.k=s                             /*only keep the pertinent sigma sums.  */
     if k==@.s  then do                       /*is it a possible amicable # ? */
                     if s==k  then iterate    /*ignore any perfect numbers.   */
                     #=#+1                    /*bump the amicable pair counter*/
                     say right(s,w) ' and ' right(k,w)  " are an amicable pair."
                     end
     end   /*k*/                       /* [↑]   process a range of integers.  */
say
say # 'amicable pairs found up to'  H  /*display the count of amicable pairs. */
                                       /*stick a fork in it,  we're all done. */
