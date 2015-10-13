/*REXX program finds and displays all  amicable pairs  up to  a given number. */
parse arg H .; if H==''  then H=20000  /*get optional arguments  (high limit).*/
w=length(H)  ; low=220                 /*W: used for columnar output alignment*/
@.=.                                   /* [↑]  LOW is lowest amicable number. */
    do k=low  for H-low;  _=sigma(k)   /*generate sigma sums for a range of #s*/
    if _>=low  then @.k=_              /*only keep the pertinent sigma sums.  */
    end   /*k*/                        /* [↑]   process a range of integers.  */
#=0                                    /*number of amicable pairs found so far*/
    do   m=low  to  H;    n=@.m        /*start the search at the lowest number*/
    if n==.  then iterate              /*if not pertinent,  then ignore the #.*/
    if m==@.n  then do                 /*If equal, might be an amicable number*/
                    if m==n  then iterate        /*skip any perfect numbers.  */
                    #=#+1                        /*bump amicable pair counter.*/
                    say right(m,w)  ' and ' right(n,w)  " are an amicable pair."
                    m=n                          /*start M (DO index)  from N.*/
                    end
    end    /*m*/
say
say # 'amicable pairs found up to'  H  /*display count of the amicable pairs. */
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
sigma: procedure; parse arg x; od=x//2 /*use either  EVEN  or  ODD  integers. */
s=1                                    /*set initial sigma sum to one.     ___*/
      do j=2+od  by 1+od  while  j*j<x /*divide by all integers up to the √ x */
      if x//j==0  then  s=s + j + x%j  /*add the two divisors to the sum.     */
      end   /*j*/                      /* [↑]  %  is REXX integer division.   */
                                       /* [↓]  adjust for square.          ___*/
            /*if j*j==x  then s=s+j*/  /*Was X a square?  If so, add the  √ x */
                                       /* [↑]  not needed for amicable #s.    */
return s                               /*return the sum of the divisors.      */
