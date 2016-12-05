/*REXX program  evaluates  a   ═════ Reverse Polish notation  (RPN) ═════   expression. */
parse arg x                                      /*obtain optional arguments from the CL*/
if x=''  then x= "3 4 2 * 1 5 - 2 3 ^ ^ / +"     /*Not specified?  Then use the default.*/
tokens=words(x)                                  /*save the  number  of  tokens   "  ". */
showSteps=1                                      /*set to 0 if working steps not wanted.*/
ox=x                                             /*save the  original  value of  X.     */
            do i=1  for tokens;   @.i=word(x,i)  /*assign the input tokens to an array. */
            end   /*i*/
x=space(x)                                       /*remove any superfluous blanks in  X. */
L=max(20, length(x))                             /*use 20 for the minimum display width.*/
numeric digits L                                 /*ensure enough decimal digits for ans.*/
say center('operand', L, "─")        center('stack', L+L, "─")           /*display title*/
Dop= '/ // % ÷';             Bop='& | &&'        /*division operators;  binary operands.*/
Aop= '- + * ^ **'  Dop Bop;  Lop=Aop "||"        /*arithmetic operators; legal operands.*/
$=                                               /*nullify the stack (completely empty).*/
       do k=1  for tokens;   ?=@.k;   ??=?       /*process each token from the  @. list.*/
       #=words($);  b=word($, max(1, #) )        /*the stack count;  the last entry.    */
                    a=word($, max(1, #-1) )      /*stack's  "first"  operand.           */
       division  =wordpos(?, Dop)\==0            /*flag:  doing a some kind of division.*/
       arith     =wordpos(?, Aop)\==0            /*flag:  doing arithmetic.             */
       bitOp     =wordpos(?, Bop)\==0            /*flag:  doing some kind of binary oper*/
       if datatype(?, 'N')   then do; $=$ ?;  call show  "add to───►stack";  iterate;  end
       if wordpos(?, Lop)==0 then do; $=e 'illegal operator:' ?;      leave; end
       if w<2                then do; $=e 'illegal RPN expression.';  leave; end
       if ?=='^'             then ??= "**"       /*REXXify  ^ ──► **   (make it legal). */
       if ?=='÷'             then ??= "/"        /*REXXify  ÷ ──► /    (make it legal). */
       if division  &  b=0   then do; $=e 'division by zero.'      ;  leave; end
       if bitOp & \isBit(a)  then do; $=e "token isn't logical: " a;  leave; end
       if bitOp & \isBit(b)  then do; $=e "token isn't logical: " b;  leave; end
       interpret 'y='   a   ??   b               /*compute with two stack operands*/
       if datatype(y, 'W')   then y=y/1          /*normalize the number with ÷ by unity.*/
       _=subword($, 1, #-2);      $=_ y          /*rebuild the stack with the answer.   */
       call show ?                               /*display (possibly)  a working step.  */
       end   /*k*/
say                                              /*display a blank line, better perusing*/
if word($,1)==e  then $=                         /*handle the special case of errors.   */
say ' RPN input:'  ox;   say " answer───►"$      /*display original input;  display ans.*/
parse source upper . y .                         /*invoked via  C.L.  or via a REXX pgm?*/
if y=='COMMAND' | \datatype($,"W")  then exit    /*stick a fork in it,  we're all done. */
                                    else exit $  /*return the answer  ───►  the invoker.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
isBit: return arg(1)==0 | arg(1)==1              /*returns   1   if arg1 is a binary bit*/
show:  if showSteps  then say center(arg(1), L)           left(space($), L);        return
