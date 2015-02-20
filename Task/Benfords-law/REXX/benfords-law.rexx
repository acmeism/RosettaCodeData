/*REXX program demonstrates some common trig functions (30 digits shown)*/
numeric digits 50                      /*use only 50 digits for LN, LOG.*/
parse arg N .;  if N=='' then N=1000   /*allow sample size specification*/
               /*══════════════apply Benford's law to Fibonacci numbers.*/
@.=1;    do j=3  to N;   jm1=j-1;   jm2=j-2;   @.j=@.jm2+@.jm1;  end /*j*/
call show_results "Benford's law applied to" N 'Fibonacci numbers'
               /*══════════════apply Benford's law to prime numbers.    */
p=0;     do j=2  until p==N; if \isPrime(j) then iterate; p=p+1; @.p=j;end
call show_results "Benford's law applied to" N 'prime numbers'
               /*══════════════apply Benford's law to factorials.       */
         do j=1  for N;      @.j=!(j);  end  /*j*/
call show_results "Benford's law applied to" N 'factorial products'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SHOW_RESULTS subroutine─────────────*/
show_results:   w1=max(length('observed'),length(N-2))              ; say
pad='   ';      w2=max(length('expected' ),length(N  ))
say pad 'digit' pad center('observed',w1) pad center('expected',w2)
say pad '─────' pad center('',w1,'─') pad center('',w2,'─') pad arg(1)
!.=0;   do j=1  for N;  _=left(@.j,1); !._=!._+1; end  /*get 1st digits.*/

        do k=1  for 9                  /*show results for Fibonacci nums*/
        say pad center(k,5) pad center(format(!.k/N,,length(N-2)),w1),
                            pad center(format(log(1+1/k),,length(N)+2),w2)
        end   /*k*/
return
/*──────────────────────────────────one─line subroutines───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────*/
!: procedure;  parse arg x; !=1;  do j=2 to x; !=!*j;  end /*j*/; return !
e: return 2.7182818284590452353602874713526624977572470936999595749669676277240766303535
isprime: procedure; parse arg x; if wordpos(x,'2 3 5 7')\==0 then return 1; if x//2==0 then return 0; if x//3==0 then return 0; do j=5 by 6 until j*j>x; if x//j==0 then return 0; if x//(j+2)==0 then return 0; end; return 1
ln10:return 2.30258509299404568401799145468436420760110148862877297603332790096757260967735248023599720508959829834196778404228624863340952546508280675666628736909878168948290720832555468084379989482623319852839350530896538
ln:procedure expose $.;parse arg x,f;if x==10 then do;_=ln10();xx=format(_);if xx\==_ then return xx;end;call e;ig=x>1.5;is=1-2*(ig\==1);ii=0;xx=x;return .ln_comp()
.ln_comp:do while ig&xx>1.5|\ig&xx<.5;_=e();do k=-1;iz=xx*_**-is;if k>=0&(ig&iz<1|\ig&iz>.5) then leave;_=_*_;izz=iz;end;xx=izz;ii=ii+is*2**k;end;x=x*e()**-ii-1;z=0;_=-1;p=z;do k=1;_=-_*x;z=z+_/k;if z=p then leave;p=z;end;return z+ii
log:return ln(arg(1))/ln(10)
