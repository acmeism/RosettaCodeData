/*REXX program lists number of chars in a fibonacci word, the word's entropy. */
d=20;     de=d+6;    numeric digits d  /*use more precision (the default is 9)*/
parse arg N .                          /*get optional argument from the C.L.  */
if N==''  then N=42                    /*Not specified?  Then use the default.*/
@.1=1;  @.2=0                          /*define some initial values of FIBword*/
say center('N',5) center('length',12) center('entropy',de) center('Fib word',56)
say copies('─',5) copies('─'     ,12) copies('─'      ,de) copies('─'       ,56)
                                       /* [↓]  display   N   fibonacci words. */
      do j=1  for N;  j1=j-1;  j2=j-2  /*use temporary variables for @ indices*/
      if j>2  then @.j=@.j1 || @.j2    /*calculate the FIBword  if we need to.*/
      L=length(@.j)
      if L<56  then Fw= @.j
               else Fw= '{the word is too wide to display.}'
      say right(j,4)  right(L,12)    '  '    entropy()    '  '    Fw;  drop @.j2
      end   /*j*/                      /*display text msg; free memory of @.j2*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
entropy: if L==1  then return left(0,d+2) /*handle special case of 1 character*/
!.0=length(space(translate(@.j, , 1), 0)) /*this is a fast way to count zeroes*/
!.1=L-!.0                                 /*also, calculate the number of ones*/
S=0;              do i=1  for 2;   _=i-1  /*construct character from the ether*/
                  S=S-!._/L*log2(!._/L)   /*add  (negatively)  the entropies. */
                  end   /*i*/
if S=1  then return left(1,d+2)           /*return a left─justified "1" (one).*/
             return format(S,,d)          /*normalize the sum  (S)  number.   */
/*────────────────────────────────────────────────────────────────────────────*/
log2: procedure; parse arg x 1 xx;   ig= x>1.5;    is=1-2*(ig\==1);    ii=0
      numeric digits digits()+5       /* [↓] precision of E must be >digits().*/
e=2.7182818284590452353602874713526624977572470936999595749669676277240766303535
  do  while  ig & xx>1.5 | \ig&xx<.5;   _=e;       do j=-1;  iz=xx* _**-is
  if j>=0 then if ig & iz<1 | \ig&iz>.5 then leave;  _=_*_;  izz=iz;  end  /*j*/
  xx=izz;  ii=ii+is*2**j;  end /*while*/;       x=x* e**-ii-1;  z=0;  _=-1;  p=z
    do k=1;   _=-_*x;   z=z+_/k;   if z=p  then leave;   p=z;   end  /*k*/
  r=z+ii;     if arg()==2  then return r;                     return r/log2(2,0)
