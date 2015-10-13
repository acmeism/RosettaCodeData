/*REXX program calculates and verifies the Hofstadter Figure─Figure sequences.*/
parse arg x top bot .                  /*obtain optional arguments from the CL*/
if   x=='' |   x==','  then   x=  10   /*Not specified?  Then use the default.*/
if top=='' | top==','  then top=1000   /* "      "         "   "   "      "   */
if bot=='' | bot==','  then bot=  40   /* "      "         "   "   "      "   */
low=1;         if x<0  then low=abs(x) /*only display a  single   │X│  value? */
r.=0;  r.1=1;  rr.=r.;  rr.1=1;  s.=r.;  s.1=2 /*initialize the R RR S arrays.*/
errs=0;  $.=0
                  do i=low  to abs(x)  /*display the 1st  X  values of  R & S.*/
                  say right('R('i") =", 20)      right(ffr(i), 7),
                      right('S('i") =", 20)      right(ffs(i), 7)
                  end   /*i*/
if x<1  then exit
                  do m=1 for  bot;     r=ffr(m);   $.r=1
                  end   /*m*/          /* [↑]  calculate the 1st 40  R values.*/

                  do n=1  for top-bot;             s=ffs(n)
                  if $.s  then call ser 'duplicate number in R and S lists:' s;   $.s=1
                  end   /*n*/          /* [↑]  calculate the 1st 960 S values.*/

                  do v=1  for top
                  if \$.v  then  call ser     'missing R │ S:'    v
                  end   /*v*/          /* [↑]  are all 1≤ numbers ≤1k present?*/
say
if errs==0  then say 'verification completed for all numbers from  1 ──►' top "  [inclusive]."
            else say 'verification failed with'      errs      "errors."
exit                                   /*stick a fork in it, we're done.*/
/*────────────────────────────────────────────────────────────────────────────*/
ffr: procedure expose r. s. rr.; parse arg n /*obtain the number from the arg.*/
     if r.n\==0  then return r.n             /*Defined? Then return the value.*/
     _=ffr(n-1) + ffs(n-1)                   /*calculate the FFR & FFS values.*/
     r.n=_;       rr._=1;        return _    /*assign value to R & RR; return.*/
/*────────────────────────────────────────────────────────────────────────────*/
ffs: procedure expose r. s. rr.; parse arg n /*search for ¬null R or S number.*/
     if s.n==0  then do k=1  for n           /* [↓]  1st IF is a SHORT CIRCUIT*/
                     if s.k\==0  then if r.k\==0  then iterate
                     call ffr k              /*define  R.k  via FFR subroutine*/
                     km=k-1;     _=s.km+1    /*the next  S  number,  possibly.*/
                     _=_+rr._;   s.k=_       /*define an element of  S  array.*/
                     end   /*k*/
     return s.n                              /*return S.n value to the invoker*/
/*────────────────────────────────────────────────────────────────────────────*/
ser: errs=errs+1;    say  '***error***!'       arg(1);                 return
