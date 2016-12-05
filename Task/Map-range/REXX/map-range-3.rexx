/*REXX program maps and displays a  range of numbers from  one range  to  another range.*/
rangeA =  0 10
rangeB = -1  0
   inc =  1
call mapRange rangeA, RangeB, inc
exit                                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
mapRange: procedure;  parse arg a1 a2, b1 b2, inc      /* [↓]  BY: either   +inc or -inc*/
                 do s=a1   to a2   by  inc  *  (1  -  2  *  sign(a2 < a1) )
                 say right(s,digits())    ' maps to '    b1 + (s-a1) * (b2-b1) / (a2-a1)
                 end   /*s*/                           /*↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑*/
          return                                       /*═══════════════t═══════════════*/
