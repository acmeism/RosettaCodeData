/*REXX pgm calculates & verifies the Hofstadter Figure-Figure sequences.*/
parse arg x highV .                    /*obtain any C.L. specifications.*/
if x=='' then x=10;  if highV=='' then highV=1000    /*use the defaults?*/
low=1;   if x<0   then low=abs(x)      /*only show a single  │X│  value.*/
r.=0;    r.1=1;    rr.=r.;    rr.1=1   /*initialize the R and RR arrays.*/
s.=0;    s.1=2;    ss.=s.;    ss.2=1   /*     "      "  S  "  SS    "   */
errs=0;  both.=0
                  do i=low  to abs(x)  /*show first X values of  R & S  */
                  say right('R('i") =",20) right(ffr(i),7),  /*show nice*/
                      right('S('i") =",20) right(ffs(i),7)   /*  R & S  */
                  end   /*i*/
if x<1  then exit                      /*if  x ≤ 0, then we're all done.*/
  do m=1 for  40;  r=ffr(m);  both.r=1 /*calculate 1st   40  R   values.*/
  end   /*m*/                          /* [↑]  build first  40 R values.*/
        do n=1 for  960;    s=ffs(n)   /*calculate 1st  960  S   values.*/
        if both.s  then call sayErr 'duplicate number in R and S lists:' s
        both.s=1                       /*indicate it's is in both array.*/
        end   /*n*/                    /* [↑] build firstt 960 S values.*/
              do v=1  for highV        /*verify all  1 ≤ # ≤ 1k present.*/
              if \both.v  then  call sayErr  'missing R │ S:'  v
              end   /*v*/              /* [↑] verify presence&uniqueness*/
say
if errs==0  then say 'verification completed for all numbers from  1 ──►' highV "  [inclusive]."
            else say 'verification failed with' errs "errors."
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────FFR subroutine──────────────────────*/
ffr: procedure expose r. s. rr. ss.;   parse arg n
if r.n\==0  then return r.n            /*Defined? Then return the value.*/
_=ffr(n-1) + ffs(n-1)                  /*calculate the  FFR  value.     */
r.n=_;       rr._=1;        return _   /*assign value to R & RR; return.*/
/*──────────────────────────────────FFS subroutine──────────────────────*/
ffs: procedure expose r. s. rr. ss.;   parse arg n
           do k=1  for n  while s.n==0 /*search for ¬null  R │ S  number*/
           if s.k\==0  then  if ffr(k)\==0  then iterate /*short circuit*/
           km=k-1;    _=s.km+1         /*the next  SS  number, possibly.*/
           _=_+rr._;  ss._=1;   s.k=_  /*define couple of  FFS  numbers.*/
           end    /*k*/
return s.n                             /*return the value to the invoker*/
/*──────────────────────────────────SAYERR subroutine───────────────────*/
sayErr: errs=errs+1; say; say '***error***!'; say; say arg(1); say; return
