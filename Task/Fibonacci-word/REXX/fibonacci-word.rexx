/*REXX program displays the number of chars in a fibonacci word, and the word's entropy.*/
d=20;     de=d+6;    numeric digits de           /*use more precision (the default is 9)*/
parse arg N .                                    /*get optional argument from the C.L.  */
if N==''  | N==","  then N=42                    /*Not specified?  Then use the default.*/
say center('N', 5)   center("length", 12)   center('entropy', de)   center("Fib word", 56)
say copies('─', 5)   copies("─"     , 12)   copies('─'      , de)   copies("─"       , 56)
c=1                                              /* [↓]  display   N   fibonacci words. */
      do j=1  for N;  if j==2  then c=0          /*test for the case of  J  equals  2.  */
      if j==3 then parse value 1 0 with a b      /*  "   "   "    "   "  "    "     3.  */
      if j>2  then c=b || a;  L=length(c)        /*calculate the FIBword  if we need to.*/
      if L<56  then Fw= c
               else Fw= '{the word is too wide to display, length is: ' L"}"
      say right(j,4)  right(L,12)    '  '    entropy()    "  "    Fw
      a=b;   b=c                                 /*define the new values for  A  and  B.*/
      end   /*j*/                                /*display text msg;                    */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
entropy: if L==1  then return left(0, d+2)       /*handle special case of one character.*/
         !.0=length( space( translate(c,,1), 0)) /*efficient way to count the  "zeroes".*/
         !.1=L-!.0; $=0;  do i=1  for 2;   _=i-1 /*construct character from the ether.  */
                          $=$ -!._/L*log2(!._/L) /*add  (negatively)  the entropies.    */
                          end   /*i*/
         if $=1  then return   left(1, d+2)      /*return a left─justified  "1"  (one). */
                      return format($,,d)        /*normalize the sum  (S)  number.      */
/*──────────────────────────────────────────────────────────────────────────────────────*/
log2: procedure; parse arg x 1 xx;  ig=x>1.5;  is=1-2*(ig\==1);  numeric digits 5+digits()
      e=2.71828182845904523536028747135266249775724709369995957496696762772407663035354759
      m=0;  do  while  ig & xx>1.5 | \ig&xx<.5;   _=e;         do j=-1;   iz=xx* _ ** - is
            if j>=0  then if ig & iz<1 | \ig&iz>.5  then leave;  _=_*_; izz=iz;  end /*j*/
            xx=izz;  m=m+is*2**j;  end /*while*/;     x=x* e** -m -1;   z=0;   _=-1;   p=z
                   do k=1;   _=-_*x;   z=z+_/k;   if z=p  then leave;   p=z;    end  /*k*/
            r=z+m;            if arg()==2  then return r;             return r / log2(2,.)
