/*REXX pgm demonstrates max tropical semi─ring with overloading: topAdd, topMul, topExp.*/
call negInf;   @x= '(x)';   @a= '(+)';   @h= '(^)';   @e= 'expression';   @c= 'comparison'
numeric digits 1000                              /*be able to handle negative infinity. */
x=   2      ; y=   -2     ;  say is(@x)  LS(x)                 RS(y)           $Mul(x,y)
x=  -0.001  ; y=  nInf    ;  say is(@a)  LS(x)                 RS(y)           $Add(x,y)
x=   0      ; y=  nInf    ;  say is(@x)  LS(x)                 RS(y)           $Mul(x,y)
x=   1.5    ; y=   -1     ;  say is(@a)  LS(x)                 RS(y)           $Add(x,y)
x=  -0.5    ; y=    0     ;  say is(@x)  LS(x)                 RS(y)           $Mul(x,y)
x=   5      ; y=    7     ;  say is(@h)  LS(x)                 RS(y)           $Exp(x,y)
x=   5      ; y= $Add(8,7);  say is(@e)  LS(x  @x)             RS(@a"(8,7)")   $Mul(x,y)
x= $Mul(5,8); y= $Mul(5,7);  say is(@e)  LS(@x"(5,8)"  @a)     RS(@x'(5,7)')   $Add(x,y)
x=   5      ; y= $Add(8,7);      blanks= left('', 26)
a= $Mul(5,8); b= $Mul(5,7);  say is(@c)  LS(x  @x)     @a"(8,7)"       '   compared to'
                             say blanks  LS(@x"(5,8)")         RS(@a @x'(5,7)')   ,
                                                   $ToF( $Mul(x,y) == $Add(a,b) )
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
ABnInf: if b==''  then b=a;  __= negInf();  _= nInf();  return a==__ | a==_ | b==__ | b==_
negInf: negInf= '-1e' || (digits()-1);  call nInf;  return negInf /*simulate a -∞ value.*/
nInf:   nInf= '-∞';                     return nInf         /*return the "diagraph": -∞ */
notNum: call sayErr "argument isn't numeric or minus infinity:", arg(1)    /*tell error.*/
is:     return 'max tropical' center(arg(1), 10)    "of"    /*center what is to be shown*/
LS:     return right( arg(1), 12)                 ' with '  /*pad  left─side of equation*/
RS:     return  left( arg(1), 12)                 ' ───► '  /* "  right─side "     "    */
sayErr: say;  say '***error***' arg(1) arg(2); say; exit 13 /*issue error message──►term*/
$Add:   procedure; parse arg a,b; return max(isRing(a),isRing(b)) /*simulate max add  ƒ */
$ToF:   procedure; parse arg ?; return word('false true',1+?)     /*return true │ false.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
$Exp:   procedure; parse arg a,b; if ABnInf() then return _ /*return the "diagraph": -∞ */
        return isRing(a) * isRing(b)                        /*simulate exponentiation ƒ */
/*──────────────────────────────────────────────────────────────────────────────────────*/
$Mul:   procedure; parse arg a,b; if ABnInf() then return _ /*return the "diagraph": -∞ */
        return isRing(a) + isRing(b)                        /*simulate multiplication ƒ */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isNum:  procedure; parse arg a,b; if ABnInf() then a= negInf()   /*replace  A  with -∞? */
        return datatype(a, 'Num')                           /*Arg numeric? Return 1 or 0*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
isRing: procedure; parse arg a,b; if ABnInf() then return negInf           /*return  -∞ */
        if isNum(a) | a==negInf()  then return a;  call notNum a           /*show error.*/
