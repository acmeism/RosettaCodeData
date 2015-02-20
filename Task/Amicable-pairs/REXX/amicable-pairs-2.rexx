/*REXX program finds/displays all  amicable pairs  up to a given number.*/
parse arg H .; if H==''  then H=20000  /*get optional arg  (high limit).*/
w=length(H)  ; H.=H || .               /*for  columnar  aligned output. */
@.=0
     do   k=1  for H;    _=Pdivs(k);   #=words(_)     /*gen proper divs.*/
       do i=1  for #;    @.k=@.k + word(_,i)          /*gen Pdivs sums. */
       end   /*i*/                     /* [↑]   sum the proper divisors.*/
     end     /*k*/                     /* [↑]   process a range of ints.*/
#=0                                    /*number of amicable pairs found.*/
     do   m=220  for H-220+1           /*start search at lowest number. */
       do n=m+1  for H-m
       if m==@.n  then if n==@.m  then do;  #=#+1    /*bump the counter.*/
                                       say right(m,w) ' and ' right(n,w) " are amicable pairs."
                                       end
       end   /*p*/
     end     /*n*/                     /*DO loop FORs:  faster than TOs.*/
say
say # 'amicable pairs found up to' H.  /*display count of amicable pairs*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────PDIVS subroutine────────────────────*/
Pdivs: procedure; parse arg x,b;  odd=x//2  /* [↑] modified for amicable*/
a=1                                    /* [↓] use only EVEN|ODD integers*/
   do j=2+odd  by 1+odd  while j*j<x   /*divide by all integers up to √x*/
   if x//j==0  then do; a=a j; b=x%j b; end /*add divs to α&ß lists if ÷*/
   end   /*j*/                         /* [↑]  %  is REXX integer divide*/
                                       /* [↓]  adjust for square.     _ */
if j*j==x  then  return  a j b         /*Was X a square?  If so, add √x.*/
                 return  a   b         /*return divisors  (both lists). */
