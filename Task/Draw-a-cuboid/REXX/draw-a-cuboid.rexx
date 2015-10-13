/*REXX program displays a cuboid  (dimensions must be positive integers).     */
parse arg  x  y  z  indent  .          /*x,y,z:   dimensions and indentation. */
x=p(x 2);     y=p(y 3);    z=p(z 4)    /*use the defaults if not specified.   */
in=p(indent 0)
                           call show   y+2  ,       ,    "+-"
       do j=1  for y;      call show   y-j+2,    j-1,    "/ |"    ;      end
                           call show        ,    y  ,    "+-|"
       do z-1;             call show        ,    y  ,    "| |"    ;      end
                           call show        ,    y  ,    "| +"
       do j=1  for y;      call show        ,    y-j,    "| /"    ;      end
                           call show        ,       ,    "+-"
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
p:     return word(arg(1), 1)          /*pick the first number or word in list*/
/*────────────────────────────────────────────────────────────────────────────*/
show:  parse arg #,$,a 2 b 3 c 4       /*get the arguments (or parts thereof).*/
      say left('',in)right(a,p(# 1))copies(b,4*x)a || right(c,p($ 0)+1);  return
