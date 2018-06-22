/*REXX program  demonstrates  some common functions  (thirty decimal digits are shown). */
numeric digits length( e() )  - 1                /*use the width of  (e)  for LN & LOG. */
parse arg N .;  if N=='' | N==","  then N= 1000  /*allow sample size to be specified.   */
LN10=ln(10)                                      /*calculate the natural log of ten #'s.*/
w1= max(2 + length('observed'), length(N-2) )    /*for aligning output for a number.    */
w2= max(2 + length('expected'), length(N  ) )    /* "      "    frequency distributions.*/
pad="   "                                        /*W1, W2: # digs past the decimal point*/
           do j=1  for 9;   #.j=pad  center( format( log( 1 + 1/j ), , length(N) + 2), w2)
           end   /*j*/                           /* [↑]  gen  9 frequencey coefficients.*/
@.=1
           do j=3  for N;   a=j-1;   b=a-1;   @.j= @.a + @.b
           end   /*j*/                           /* [↑]  generate  N  Fibonacci numbers.*/
call show "Benford's law applied to"      N      'Fibonacci numbers'
@.1=1
           do j=1  for N;                     @.j= @.j * N
           end   /*j*/                           /* [↑]  generate  N  factorials.       */
call show "Benford's law applied to"      N      'factorial products'
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
e:       return  2.71828182845904523536028747135266249775724709369995957496696762772407663
log:     return ln( arg(1) )    /   LN10
ln:      procedure; arg x; e=e(); _=e; ig=(x>1.5); is=1-2*(ig\=1); i=0; s=x;  return .ln()
/*──────────────────────────────────────────────────────────────────────────────────────*/
.ln:     do while ig&s>1.5 | \ig&s<.5
           do k=-1; iz=s*_**-is; if k>=0 & (ig&iz<1 | \ig&iz>.5) then leave; _=_*_; izz=iz
           end   /*k*/
         s=izz;  i=i + is* 2**k; end   /*while*/;    x=x * e** - i - 1;  z=0; _=-1;  p=z
           do k=1;_= -_ * x; z=z + _/k; if z=p  then leave; p=z; end /*k*/;     return z+i
/*──────────────────────────────────────────────────────────────────────────────────────*/
show:    say;  say pad  ' digit '   pad  center("observed",w1)  pad  center('expected',w2)
         say pad  '───────'  pad   center("",w1,'─')  pad  center("",w2,'─')   pad  arg(1)
         !.=0;  do j=1  for N;  _=left(@.j, 1);    !._= !._ +1      /*get the 1st digit.*/
                end   /*j*/

                do f=1  for 9                                       /*show the results. */
                say pad  center(f,7)  pad  center( format( !.f/N, , length(N-2)), w1)  #.f
                end   /*k*/
         return
