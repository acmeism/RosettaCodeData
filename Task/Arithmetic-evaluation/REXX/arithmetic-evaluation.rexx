/*REXX pgm evaluates an infix-type arithmetic expression & shows result.*/
nchars = '0123456789.eEdDqQ'           /*possible parts of a #,  sans ± */
e='***error!***';   $=' ';     doubleOps='&|*/';      z=
parse arg x 1 ox1;    if x=''  then call serr 'no input was specified.'
x=space(x);   L=length(x);     x=translate(x,'()()',"[]{}")

j=0; do forever;  j=j+1;  if j>L  then leave;  _=substr(x,j,1);  _2=getX()
     newT=pos(_,' ()[]{}^÷')\==0;  if newT  then do; z=z _ $; iterate; end
     possDouble=pos(_,doubleOps)\==0   /*is _ a possible double operator*/
     if possDouble then do             /*is this a possible double oper?*/
                        if _2==_  then do        /*yup, it's one of 'em.*/
                                       _=_||_    /*use a double operator*/
                                       x=overlay($,x,Nj) /*blank out the*/
                                       end               /*  2nd symbol.*/
                        z=z _ $;  iterate
                        end
     if _=='+' | _=="-"  then do;  p_=word(z,words(z))   /*last  Z token*/
                              if p_=='('   then z=z 0    /handle unary ±*/
                              z=z _ $;     iterate
                              end
     lets=0;  sigs=0;  #=_

            do j=j+1  to L;   _=substr(x,j,1)    /*build a valid number.*/
            if lets==1 & sigs==0 then if _=='+' | _=='-'  then do;  sigs=1
                                                               #=# || _
                                                               iterate
                                                               end /*exp*/
            if pos(_,nchars)==0  then leave
            lets=lets+datatype(_,'M')  /*keep track of # of exponents.  */
            #=# || translate(_,'EEEEE','eDdQq')  /*keep buildingthe num.*/
            end   /*j*/
     j=j-1
     if \datatype(#,'N') then call serr 'invalid number: ' #
     z=z # $
     end   /*forever*/

_=word(z,1); if _=='+' | _=='-' then z=0 z         /*handle unary cases.*/
x='(' space(z) ') ';  tokens=words(x)  /*force stacking for expression. */
  do i=1  for tokens;  @.i=word(x,i);  end /*i*/   /*assign input tokens*/
L=max(20,length(x))                    /*use 20 for the min show width. */
op=')(-+/*^';  rOp=substr(op,3);  p.=;  s.=;  n=length(op);  epr=;  stack=

  do i=1  for n; _=substr(op,i,1); s._=(i+1)%2; p._=s._+(i==n);  end /*i*/
                                       /*[↑] assign operator priorities.*/
  do #=1  for tokens;   ?=@.#          /*process each token from @. list*/
  if ?=='**'      then ?="^"           /*convert REXX-type exponentation*/
     select                            /*@.# is: (, operator, ), operand*/
     when ?=='('  then stack='(' stack
     when isOp(?) then do                        /*is token an operator?*/
                       !=word(stack,1)           /*get token from stack.*/
                         do  while !\==')' & s.!>=p.?;  epr=epr !  /*add*/
                         stack=subword(stack,2); /*del token from stack.*/
                         !=word(stack,1)         /*get token from stack.*/
                         end   /*while ···)*/
                       stack=? stack             /*add token  to  stack.*/
                       end
     when ?==')' then do;   !=word(stack,1)      /*get token from stack.*/
                        do  while !\=='(';     epr=epr !   /*add to epr.*/
                        stack=subword(stack,2)   /*del token from stack.*/
                        !=word(stack,1)          /*get token from stack.*/
                        end   /*while ···( */
                      stack=subword(stack,2)     /*del token from stack.*/
                      end
    otherwise  epr=epr ?                         /*add operand to  epr. */
    end   /*select*/
  end     /*#*/

epr=space(epr stack);     tokens=words(epr);     x=epr;     z=;     stack=
  do i=1  for tokens; @.i=word(epr,i);  end /*i*/  /*assign input tokens*/
dop='/ // % ÷';           bop='& | &&' /*division   ops; binary operands*/
aop='- + * ^ **' dop bop; lop=aop '||' /*arithmetic ops; legal  operands*/

  do #=1  for tokens;   ?=@.#;  ??=?   /*process each token from @. list*/
  w=words(stack);  b=word(stack,max(1,w))     /*stack count; last entry.*/
                   a=word(stack,max(1,w-1))   /*stack's "first" operand.*/
  division  =wordpos(?,dop)\==0               /*flag:  doing a division.*/
  arith     =wordpos(?,aop)\==0               /*flag:  doing arithmetic.*/
  bitOp     =wordpos(?,bop)\==0               /*flag:  doing binary math*/
  if datatype(?,'N')   then do; stack=stack ?;                iterate; end
  if wordpos(?,lop)==0 then do; z=e 'illegal operator:' ?;      leave; end
  if w<2               then do; z=e 'illegal epr expression.';  leave; end
  if ?=='^'            then ??="**"    /*REXXify  ^ ──► **  (make legal)*/
  if ?=='÷'            then ??="/"     /*REXXify  ÷ ──► /   (make legal)*/
  if division  &  b=0  then do; z=e 'division by zero: '    b;  leave; end
  if bitOp & \isBit(a) then do; z=e "token isn't logical: " a;  leave; end
  if bitOp & \isBit(b) then do; z=e "token isn't logical: " b;  leave; end
    select                                    /*perform arith. operation*/
    when ??=='+'             then y = a +  b
    when ??=='-'             then y = a -  b
    when ??=='*'             then y = a *  b
    when ??=='/' | ??=="÷"   then y = a /  b
    when ??=='//'            then y = a // b
    when ??=='%'             then y = a %  b
    when ??=='^' | ??=="**"  then y = a ** b
    when ??=='||'            then y = a || b
    otherwise                   z=e 'invalid operator:' ?;      leave
    end   /*select*/
  if datatype(y,'W')   then y=y/1      /*normalize number with  ÷  by 1.*/
  _=subword(stack,1,w-2);   stack=_ y  /*rebuild the stack with answer. */
  end   /*#*/

if word(z,1)==e  then stack=           /*handle special case of errors. */
z=space(z stack)                       /*append any residual entries.   */
say 'answer──►' z                      /*display the answer (result).   */
parse source upper . how .             /*invoked via  C.L.  or REXX pgm?*/
if how=='COMMAND' | ,
   \datatype(z,'W') then exit          /*stick a fork in it, we're done.*/
return z                               /*return  Z ──► invoker (RESULT).*/
/*──────────────────────────────────subroutines─────────────────────────*/
isBit: return arg(1)==0 | arg(1)==1    /*returns  1  if arg1 is bin bit.*/
isOp:  return pos(arg(1),rOp)\==0      /*is argument1 a "real" operator?*/
serr:  say; say e arg(1); say; exit 13 /*issue an error message with txt*/
/*──────────────────────────────────GETX subroutine─────────────────────*/
getX:  do Nj=j+1  to length(x);  _n=substr(x,Nj,1); if _n==$  then iterate
       if _n==$   then iterate;  return  substr(x,Nj,1)  /*ignore blanks*/
       end   /*Nj*/
return $                               /*reached end-of-tokens, return $*/
