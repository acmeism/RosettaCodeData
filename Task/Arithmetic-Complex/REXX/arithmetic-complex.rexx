/*REXX program  demonstrates how to support some  math functions  for  complex numbers. */
x = '(5,3i)'                                     /*define  X    ─── can use  I i J or j */
y = "( .5,  6j)"                                 /*define  Y         "   "   " " "  " " */

say '      addition:   '        x        " + "         y         ' = '          Cadd(x, y)
say '   subtraction:   '        x        " - "         y         ' = '          Csub(x, y)
say 'multiplication:   '        x        " * "         y         ' = '          Cmul(x, y)
say '      division:   '        x        " ÷ "         y         ' = '          Cdiv(x, y)
say '       inverse:   '        x        "                         = "          Cinv(x, y)
say '  conjugate of:   '        x        "                         = "          Conj(x, y)
say '   negation of:   '        x        "                         = "          Cneg(x, y)
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Conj: procedure; parse arg a ',' b,c ',' d;   call C#;    return C$(  a      ,  -b    )
Cadd: procedure; parse arg a ',' b,c ',' d;   call C#;    return C$(  a+c    ,   b+d  )
Csub: procedure; parse arg a ',' b,c ',' d;   call C#;    return C$(  a-c    ,   b-d  )
Cmul: procedure; parse arg a ',' b,c ',' d;   call C#;    return C$( ac-bd   ,   bc+ad)
Cdiv: procedure; parse arg a ',' b,c ',' d;   call C#;    return C$((ac+bd)/s,  (bc-ad)/s)
Cinv: return  Cdiv(1,  arg(1))
Cneg: return  Cmul(arg(1), -1)
C_:   return  word(translate(arg(1), , '{[(JjIi)]}')  0,  1)                /*get # or 0*/
C#:   a=C_(a); b=C_(b); c=C_(c); d=C_(d); ac=a*c; ad=a*d; bc=b*c; bd=b*d;s=c*c+d*d; return
C$:   parse arg r,c;    _='['r;   if c\=0  then _=_","c'j';   return _"]"   /*uses  j   */
