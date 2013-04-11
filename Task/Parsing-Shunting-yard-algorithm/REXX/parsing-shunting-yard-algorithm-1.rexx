/*REXX pgm converts infix arith. expressions to Reverse Polish notation.*/
parse arg x;    if x=''  then x = '3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3';    ox=x
showSteps=1               /*set to 0 (zero) if working steps not wanted.*/
x='(' space(x) ') ';  tokens=words(x)  /*force stacking for expression. */
  do i=1  for tokens;  @.i=word(x,i);  end /*i*/   /*assign input tokens*/
L=max(20,length(x))                    /*use 20 for the min show width. */
say 'token' center('input',L,'─') center('stack',L%2,'─') center('output',L,'─') center('action',L,'─')
pad=left('',5);    op=')(-+/*^';    rOp=substr(op,3);    p.=;    s.=;    n=length(op);   RPN=;   stack=

  do i=1  for n;   _=substr(op,i,1);   s._=(i+1)%2;   p._=s._+(i==n);  end  /*i*/
                                       /*[↑] assign operator priorities.*/
  do #=1  for tokens;   ?=@.#          /*process each token from @. list*/
     select                            /*@.# is: (, operator, ), operand*/
     when ?=='('  then do; stack='(' stack; call show 'moving' ? "──► stack"; end
     when isOp(?) then do                        /*is token an operator?*/
                       !=word(stack,1)           /*get token from stack.*/
                         do  while !\==')' & s.!>=p.?;  RPN=RPN !  /*add*/
                         stack=subword(stack,2); /*del token from stack.*/
                         call show 'unstacking:' !
                         !=word(stack,1)         /*get token from stack.*/
                         end   /*while ···)*/
                       stack=? stack             /*add token  to  stack.*/
                       call show 'moving' ? "──► stack"
                       end
     when ?==')' then do;   !=word(stack,1)      /*get token from stack.*/
                        do  while !\=='(';     RPN=RPN !   /*add to RPN.*/
                        stack=subword(stack,2)   /*del token from stack.*/
                        !=word(stack,1)          /*get token from stack.*/
                        call show 'moving stack' ! '──► RPN'
                        end   /*while ···( */
                      stack=subword(stack,2)     /*del token from stack.*/
                      call show 'deleting ( from the stack'
                      end
    otherwise  RPN=RPN ?                         /*add operand to  RPN. */
               call show 'moving' ? '──► RPN'
    end   /*select*/
  end     /*#*/

RPN=space(RPN stack)
say;  say  'input:'  ox;    say 'RPN──►' RPN   /*show input and the RPN.*/
parse source upper . y .               /*invoked via  C.L.  or REXX pgm?*/
if y=='COMMAND'  then  exit            /*stick a fork in it, we're done.*/
                 else  return RPN      /*return RPN to invoker (RESULT).*/
/*──────────────────────────────────ISOP subroutine─────────────────────*/
isOp: return pos(arg(1),rOp)\==0       /*is argument1 a "real" operator?*/
/*──────────────────────────────────SHOW subroutine─────────────────────*/
show: if showSteps  then say  center(?,length(pad))  left(subword(x,#),L),
                         left(stack,L%2) left(space(RPN),L) arg(1); return
