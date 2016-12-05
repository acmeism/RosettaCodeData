/*REXX program  calculates and displays all  amicable pairs  up to  a given number.     */
parse arg H .;   if H=='' | H==","  then H=20000 /*get optional arguments  (high limit).*/
w=length(H)  ;   low=220                         /*W: used for columnar output alignment*/
x=220 34765731 6232 87633 284 12285 10856 36939357 6368 5684679           /*S  minimums.*/
   do i=0 for 10;  $.i=word(x,i+1);  end  /*i*/  /*minimum amicable #s for last dec dig.*/
f.=0;   do p=0  until f.p>10**digits();  f.p=4**p;  end  /*p*/         /*calc. pows of 4*/
#=0                                              /*number of amicable pairs found so far*/
@.=                                              /* [↑]  LOW is lowest amicable number. */
     do k=low  for H-low+1                       /*generate sigma sums for a range of #s*/
     parse var k  ''  -1  D                      /*obtain last decimal digit of   K.    */
     if k<$.D     then iterate                   /*if no need to compute, then skip it. */
     od=k//2                                     /*OD:   set to  unity  if   K   is odd.*/
     z=k; q=1;  do p=0  while f.p<=z; q=f.p; end /*R  will end up being the  iSqrt of Z.*/
     r=0;  do while q>1; q=q%4; _=z-r-q; r=r%2;  if _>=0  then do;  z=_; r=r+q;  end;  end
     s=1                                         /*set initial sigma sum to unity.   ___*/
           do j=2+od  by 1+od  to r              /*divide by all integers up to the √ K */
           if k//j==0  then s=s+ j + k%j         /*add the two divisors to the sum.     */
           end   /*j*/                           /* [↑]  %  is REXX integer division.   */
     @.k=s                                       /*only keep the pertinent sigma sums.  */
     if k==@.s  then do                          /*is it a possible amicable number ?   */
                     if s==k  then iterate       /*Is it a perfect number?  Then skip it*/
                     #=#+1                       /*bump the amicable pair counter.      */
                     say right(s,w)     ' and '     right(k,w)    " are an amicable pair."
                     end
     end   /*k*/                                 /* [↑]   process a range of integers.  */
say                                              /*stick a fork in it,  we're all done. */
say #   'amicable pairs found up to'    H        /*display the count of amicable pairs. */
