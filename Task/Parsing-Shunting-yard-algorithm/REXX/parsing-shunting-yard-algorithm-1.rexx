/*REXX pgm converts infix arith. expressions to Reverse Polish notation (shunting─yard).*/
parse arg x                                      /*obtain optional argument from the CL.*/
if x=''  then x= '3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3' /*Not specified?  Then use the default.*/
ox=x
x='(' space(x) ") "                              /*force stacking for the expression.   */
#=words(x)                                       /*get number of tokens in expression.  */
              do i=1  for #;   @.i=word(x, i)    /*assign the input tokens to an array. */
              end   /*i*/
tell=1                                           /*set to 0 if working steps not wanted.*/
L=max( 20, length(x) )                           /*use twenty for the minimum show width*/

say  'token'  center("input" , L, '─')     center("stack" , L%2, '─'),
              center("output", L, '─')     center("action", L,   '─')
op= ")(-+/*^";   Rop=substr(op,3);   p.=;  n=length(op);  RPN=  /*some handy-dandy vars.*/
s.=
   do i=1  for n;  _=substr(op,i,1);  s._=(i+1)%2;   p._=s._+(i==n);  end  /*i*/
$=                                               /* [↑]  assign the operator priorities.*/
   do k=1  for #;              ?=@.k             /*process each token from the  @. list.*/
     select                                      /*@.k is:  (,  operator,   ),   operand*/
     when ?=='('   then do; $="(" $;    call show 'moving'   ?   "──► stack";    end
     when isOp(?)  then do;              !=word($, 1)             /*get token from stack*/
                               do  while ! \==')'  &  s.!>=p.?
                               RPN=RPN !                          /*add token  to   RPN.*/
                               $=subword($, 2)                    /*del token from stack*/
                               call show 'unstacking:'  !
                               !=word($, 1)                       /*get token from stack*/
                               end   /*while*/
                        $=? $                                     /*add token  to  stack*/
                        call show 'moving'   ?   "──► stack"
                        end
     when ?==')'   then do;             !=word($, 1)              /*get token from stack*/
                             do  while  !\=='(';     RPN=RPN !    /*add token  to  RPN. */
                             $=subword($, 2)                      /*del token from stack*/
                             !=   word($, 1)                      /*get token from stack*/
                             call show 'moving stack' ! "──► RPN"
                             end   /*while*/
                        $=subword($, 2)                           /*del token from stack*/
                        call show 'deleting ( from the stack'
                        end
     otherwise  RPN=RPN ?                                         /*add operand to RPN. */
                call show 'moving'     ?     "──► RPN"
    end   /*select*/
   end    /*k*/
say
RPN=space(RPN $)                                 /*elide any superfluous blanks in RPN. */
say ' input:'  ox;     say " RPN──►"    RPN      /*display the input  and  the RPN.     */
parse source upper . y .                         /*invoked via the  C.L.  or  REXX pgm? */
if y=='COMMAND'  then  exit                      /*stick a fork in it,  we're all done. */
                 else  return RPN                /*return RPN to invoker  (the RESULT). */
/*──────────────────────────────────────────────────────────────────────────────────────────*/
isOp: return pos(arg(1),rOp) \== 0               /*is the first argument a "real" operator? */
show: if tell then say center(?,5) left(subword(x,k),L) left($,L%2) left(RPN,L) arg(1); return
