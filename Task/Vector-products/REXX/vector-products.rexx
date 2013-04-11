/*REXX program computes the products:    the  dot          product,     */
/*                                       the cross         product,     */
/*                                       the scalar triple product,  and*/
/*                                       the vector triple product.     */

a =   3   4   5                        /*positive numbers don't need  " */
b =   4   3   5
c = "-5 -12 -13"

call tellV 'vector A =',a              /*show the  A  vector, aligned #s*/
call tellV 'vector B =',b              /*show the  B  vector, aligned #s*/
call tellV 'vector C =',c              /*show the  C  vector, aligned #s*/
say
call tellV '  dot product [A∙B] =',dot(a,b)
call tellV 'cross product [AxB] =',cross(a,b)
call tellV 'scalar triple product [A∙(BxC)] =',dot(a,cross(b,c))
call tellV 'vector triple product [Ax(BxC)] =',cross(a,cross(b,c))
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────cross subroutine─────────────────*/
cross: procedure; parse arg x1 x2 x3,y1 y2 y3       /*the CROSS product.*/
       return x2*y3-x3*y2 x3*y1-x1*y3 x1*y2-x2*y1   /*a vector quantity.*/
/*─────────────────────────────────────dot subroutine───────────────────*/
dot: procedure; parse arg x1 x2 x3,y1 y2 y3         /*the  DOT  product.*/
     return x1*y1 + x2*y2 + x3*y3                   /*a scaler quantity.*/
/*─────────────────────────────────────tellV subroutine─────────────────*/
tellV: procedure; parse arg name,x y z              /*display the vector*/
       w=max(4,length(x),length(y),length(z))       /*max width of nums.*/
       say right(name,40) right(x,w) right(y,w) right(z,w)
       return
