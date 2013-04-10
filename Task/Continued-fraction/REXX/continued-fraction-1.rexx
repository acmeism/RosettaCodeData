/*REXX program calculates and displays values of some specific continued*/
/*───────────── fractions   (along with their   α   and   ß   terms).   */
/*───────────── Continued fractions: also known as anthyphairetic ratio.*/
T=500                                  /*use 500 terms for calculations.*/
showDig=100; numeric digits 2*showDig  /*use 100 digits for the display.*/
a=;  @=;  b=                           /*omitted ß terms are assumed = 1*/
/*══════════════════════════════════════════════════════════════════════*/
a=1 rep(2);                                             call tell '√2'
/*══════════════════════════════════════════════════════════════════════*/
a=1 rep(1 2);                                           call tell '√3'        /*also:  2∙sin(π/3)    */
/*══════════════════════════════════════   ___  ════════════════════════*/
                           /*generalized  √ N   */
      do N=2 to 11;        a=1 rep(2); b=rep(N-1);      call tell 'gen √'N;   end
N=1/2;                     a=1 rep(2); b=rep(N-1);      call tell 'gen √½'
/*══════════════════════════════════════════════════════════════════════*/
      do j=1 for T;        a=a j; end;   b=1 a; a=2 a;  call tell 'e'
/*══════════════════════════════════════════════════════════════════════*/
      do j=1 for T by 2;   a=a j;        b=b j+1; end;  call tell '1÷[√e-1]'
/*══════════════════════════════════════════════════════════════════════*/
      do j=1 for T;        a=a j;     end; b=a; a=0 a;  call tell '1÷[e-1]'
/*══════════════════════════════════════════════════════════════════════*/
a=1 rep(1);                                             call tell 'φ, phi'
/*══════════════════════════════════════════════════════════════════════*/
a=1;  do j=1 for T by 2;   a=a j 1;   end;              call tell 'tan(1)'
/*══════════════════════════════════════════════════════════════════════*/
a=1;  do j=1 for T;        a=a 2*j+1; end;              call tell 'coth(1)'
/*══════════════════════════════════════════════════════════════════════*/
a=2;  do j=1 for T;        a=a 4*j+2; end;              call tell 'coth(½)'   /*also:  [e+1] ÷ [e-1] */
/*══════════════════════════════════════════════════════════════════════*/
T=10000
a=1 rep(2)
      do j=1 for T by 2;   b=b j**2;  end;              call tell '4÷π'
/*══════════════════════════════════════════════════════════════════════*/
T=10000
a=1;  do j=1 for T;        a=a 1/j; @=@ '1/'j; end;     call tell '½π, ½pi'
/*══════════════════════════════════════════════════════════════════════*/
T=10000
a=0 1 rep(2)
      do j=1 for T by 2;   b=b j**2;     end;   b=4 b;  call tell 'π, pi'
/*══════════════════════════════════════════════════════════════════════*/
T=10000
a=0;  do j=1 for T; a=a j*2-1; b=b j**2; end;   b=4 b;  call tell 'π, pi'
/*══════════════════════════════════════════════════════════════════════*/
T=100000
a=3 rep(6)
      do j=1 for T by 2;       b=b j**2; end;           call tell 'π, pi'
exit                                   /*stick a fork in it, we're done.*/

/*────────────────────────────────CF subroutine─────────────────────────*/
cf: procedure;  parse arg C x,y;      !=0;      numeric digits  digits()+5
           do k=words(x) to 1 by -1;   a=word(x,k);  b=word(word(y,k) 1,1)
           d=a+!;  if d=0 then call divZero  /*in case divisor is bogus.*/
           !=b/d                             /*here's a binary mosh pit.*/
           end   /*k*/
return !+C
/*────────────────────────────────DIVZERO subroutine────────────────────*/
divZero: say;  say '***error!***';  say 'division by zero.';  say; exit 13
/*────────────────────────────────GETT subroutine───────────────────────*/
getT: parse arg stuff,width,ma,mb,_
                do m=1; mm=m+ma; mn=max(1,m-mb);   w=word(stuff,m)
                w=right(w,max(length(word(As,mm)),length(word(Bs,mn)),length(w)))
                if length(_ w)>width  then leave   /*stop getting terms?*/
                _=_ w                              /*whole, don't chop. */
                end   /*m*/                        /*done building terms*/
return strip(_)                                    /*strip leading blank*/
/*────────────────────────────────REP subroutine────────────────────────*/
rep:     parse arg rep;        return  space(copies(' 'rep, T%words(rep)))
/*────────────────────────────────RF subroutine─────────────────────────*/
rf: parse arg xxx,z
         do m=1 for T; w=word(xxx,m)    ;  if w=='1/1' | w=1  then w=1
         if w=='1/2' | w=1/2  then w='½';  if w=-.5           then w='-½'
         if w=='1/4' | w=1/4  then w='¼';  if w=-.25          then w='-¼'
         z=z w
         end
return z                                           /*done re-formatting.*/
/*────────────────────────────────TELL subroutine───────────────────────*/
tell: parse arg ?; v=cf(a,b); numeric digits showdig; As=rf(@ a); Bs=rf(b)
      say right(?,8)   '='   left(v/1,showdig)   '  α terms= '   getT(As,72  ,0,1)
      if b\=='' then say right('',8+2+showdig+1) '  ß terms=   ' getT(Bs,72-2,1,0)
      a=;  @=;  b=;   return
