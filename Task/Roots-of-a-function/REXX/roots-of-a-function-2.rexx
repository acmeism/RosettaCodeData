/* REXX */
Parse Version v; Say v
n=1000000
Say 'N='n
Call time 'R'; Do i=1 To n; xx=f1(5); End; Say 'f1' xx time('E')
Call time 'R'; Do i=1 To n; xx=f2(5); End; Say 'f2' xx time('E')
Call time 'R'; Do i=1 To n; xx=f3(5); End; Say 'f3' xx time('E')
Exit
f1: procedure;   parse arg x;   return  x**3  -  3 * x**2   +   2 * x
f2: procedure;   parse arg x;   x2=x*x; return x*x2 - 3*x2 + x+x
f3: Return((arg(1)-3)*arg(1)+2)*arg(1)
