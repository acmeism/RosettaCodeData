/*REXX program  evaluates  a  Reverse Polish notation (RPN)  expression.*/
parse arg x;    if x=''  then x = '3 4 2 * 1 5 - 2 3 ^ ^ / +';        ox=x
showSteps=1               /*set to 0 (zero) if working steps not wanted.*/
x=space(x);   tokens=words(x)          /*elide extra blanks;count tokens*/
  do i=1  for tokens;  @.i=word(x,i);  end /*i*/   /*assign input tokens*/
L=max(20,length(x))                    /*use 20 for the min show width. */
numeric digits L                       /*ensure enough digits for answer*/
say center('operand',L,'─') center('stack',L*2,'─');      e='***error!***'
add2s='add to───►stack';  z=;          stack=
dop='/ // % ÷';           bop='& | &&' /*division   ops; binary operands*/
aop='- + * ^ **' dop bop; lop=aop '||' /*arithmetic ops; legal  operands*/

  do #=1  for tokens;   ?=@.#;  ??=?   /*process each token from @. list*/
  w=words(stack);  b=word(stack,max(1,w))     /*stack count; last entry.*/
                   a=word(stack,max(1,w-1))   /*stack's "first" operand.*/
  division  =wordpos(?,dop)\==0               /*flag:  doing a division.*/
  arith     =wordpos(?,aop)\==0               /*flag:  doing arithmetic.*/
  bitOp     =wordpos(?,bop)\==0               /*flag:  doing binary math*/
  if datatype(?,'N') then do; stack=stack ?; call show add2s; iterate; end
  if wordpos(?,lop)==0 then do; z=e 'illegal operator:' ?;      leave; end
  if w<2               then do; z=e 'illegal RPN expression.';  leave; end
  if ?=='^'            then ??="**"    /*REXXify  ^ ──► **  (make legal)*/
  if ?=='÷'            then ??="/"     /*REXXify  ÷ ──► /   (make legal)*/
  if division  &  b=0  then do; z=e 'division by zero: '    b;  leave; end
  if bitOp & \isBit(a) then do; z=e "token isn't logical: " a;  leave; end
  if bitOp & \isBit(b) then do; z=e "token isn't logical: " b;  leave; end
  interpret 'y=' a ?? b                /*compute with two stack operands*/
  if datatype(y,'W')   then y=y/1      /*normalize number with  ÷  by 1.*/
  _=subword(stack,1,w-2);   stack=_ y  /*rebuild the stack with answer. */
  call show ?
  end   /*#*/

if word(z,1)==e then stack=            /*handle special case of errors. */
z=space(z stack)                       /*append any residual entries.   */
say;  say ' RPN input:'  ox;    say '  answer──►' z  /*show input & ans.*/
parse source upper . how .             /*invoked via  C.L.  or REXX pgm?*/
if how=='COMMAND' | ,
   \datatype(z,'W') then exit          /*stick a fork in it, we're done.*/
return z                               /*return  Z ──► invoker (RESULT).*/
/*──────────────────────────────────subroutines─────────────────────────*/
isBit: return arg(1)==0 | arg(1)==1    /*returns  1  if arg1 is bin bit.*/
show:  if showSteps then say center(arg(1),L) left(space(stack),L); return
