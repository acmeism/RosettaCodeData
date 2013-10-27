/*REXX pgm to calculate & verify the Hofstadter Figure-Figure sequences.*/
parse arg x highV .                    /*obtain any C.L. specifications.*/
if x=='' then x=10;  if highV=='' then highV=1000    /*use the defaults?*/
low=1                                  /*use unity as the starting point*/
if x<0   then low=abs(x)               /*only show a single  │X│  value.*/
r.=0;    r.1=1;    rr.=r.;    rr.1=1   /*initialize the R and RR arrays.*/
s.=0;    s.1=2;    ss.=s.;    ss.2=1   /*     "      "  S  "  SS    "  .*/
errs=0
                  do i=low  to abs(x)  /*show first X values of  R & S  */
                  say right('R('i") =",20) right(ffr(i),7),  /*show nice*/
                      right('S('i") =",20) right(ffs(i),7)   /*  R & S  */
                  end   /*i*/
if x<1 then exit                       /*stick a fork in it, we're done.*/
/*═══════════════════════════════════════verify 1st 1k: unique & present*/
both.=0                                /*initialize the  BOTH  array.   */
                                       /*build list of 1st  40 R values.*/
  do m=1 for  40;     r=ffr(m)         /*calculate 1st   40  R   values.*/
  both.r=1                             /*build the  BOTH  array.        */
  end   /*m*/

     do n=1 for  960;    s=ffs(n)      /*calculate 1st  960  S   values.*/
     if both.s  then call sayErr 'duplicate number in R and S lists:' s
     both.s=1                          /*add to the  BOTH  array.       */
     end   /*n*/
                                       /*verify presence and uniqueness.*/
        do v=1  for highV              /*verify all  1 ≤ # ≤ 1k present.*/
        if \both.v  then call sayErr 'missing R │ S:'  v
        end   /*v*/
say
@v='verification'; @i="  [inclusive]." /*shortcuts to shorten prog width*/
if errs==0  then say @v 'completed for all numbers from  1 ──►' highV @i
            else say @v 'failed with' errs "errors."
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────FFR subroutine──────────────────────*/
ffr: procedure expose r. s. rr. ss.;   parse arg n
if r.n\==0  then return r.n            /*Defined? Then return the value.*/
_=ffr(n-1)+ffs(n-1)                    /*calculate the  FFR  value.     */
r.n=_;       rr._=1                    /*assign the value to  R  and RR.*/
return _                               /*return the value to the invoker*/
/*──────────────────────────────────FFS subroutine──────────────────────*/
ffs: procedure expose r. s. rr. ss.;   parse arg n
           do k=1  for n  while s.n==0 /*search for not null  R │ S num.*/
           if s.k\==0  then  if ffr(k)\==0  then iterate /*short circuit*/
           km=k-1;    _=s.km+1         /*the next  SS  number, possibly.*/
           _=_+rr._                    /*maybe adjust for the  FRR  num.*/
           s.k=_;     ss._=1           /*define couple of  FFS  numbers.*/
           end    /*k*/
return s.n                   /*return the value to the invoker*/
/*──────────────────────────────────SAYERR subroutine───────────────────*/
sayErr: errs=errs+1; say; say '***error***!'; say; say arg(1); say; return
