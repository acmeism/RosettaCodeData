/*REXX program  demonstrates  some common functions  (thirty decimal digits are shown). */
numeric digits 50                                /*use only 50 dec digits for  LN & LOG.*/
parse arg N .;    if N=='' | N==","  then N=1000 /*allow sample size to be specified.   */
@benny= "Benford's law applied to"               /*a handy-dandy literal for some SAYs. */
w1= max(2+length('observed'), length(N-2) );   pad="   "     /*used for aligning output.*/
w2= max(2+length('expected'), length(N  ) )                  /*  "   "      "       "   */

@.=1;      do j=3  to N;             jm1=j-1;   jm2=j-2;   @.j=@.jm2 + @.jm1;    end /*j*/
call show @benny  N  'Fibonacci numbers'
p=1
@.1=2;     do j=3 by 2  until p==N;  if \isPrime(j)  then iterate; p=p+1; @.p=j; end /*j*/
call show @benny  N  'prime numbers'

!=1;       do j=1  for N;            !=!*j;                                      end /*j*/
call show @benny  N  'factorial products'
exit                                             /*stick a fork in it,  we're all done. */
/*───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────*/
e:       return 2.7182818284590452353602874713526624977572470936999595749669676277240766303535
isPrime: procedure; parse arg x; if wordpos(x,'2 3 5 7')\==0 then return 1; if x//2==0 then return 0; if x//3==0 then return 0;  do j=5 by 6 until j*j>x; if x//j==0 then return 0; if x//(j+2)==0 then return 0; end; return 1
ln:      procedure; parse arg x; _=e();  ig=(x>1.5);  is=1 - 2 * (ig \== 1);  ii=0;  s=x;   return .ln()
.ln:     do while ig&s>1.5|\ig&s<.5;do k=-1;iz=s*_**-is;if k>=0&(ig&iz<1|\ig&iz>.5) then leave;_=_*_;izz=iz;end;s=izz;ii=ii+is*2**k;end;x=x*e()**-ii-1;z=0;_=-1;p=z;do k=1;_=-_*x;z=z+_/k;if z=p then leave;p=z;end;return z+ii
log:     return ln( arg(1) )  /  ln(10)
/*──────────────────────────────────────────────────────────────────────────────────────*/
show:    say;  say pad  ' digit '   pad  center("observed",w1)  pad  center('expected',w2)
         say pad  '───────'  pad   center("",w1,'─')  pad  center("",w2,'─')   pad  arg(1)
         !.=0;   do j=1  for N;  _=left(@.j,1);  !._=!._+1;   end      /*get 1st digits.*/

                 do k=1  for 9                   /*display results for  decimal digits. */
                 say pad center(k,7) pad center(format(!.k     /N  , , length(N-2) ), w1),
                                     pad center(format(log(1+1 /k) , , length(N)+2 ), w2)
                 end   /*k*/
         return
