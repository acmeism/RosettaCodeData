/*REXX program computes the products:  dot,  cross,  scalar triple,  and  vector triple.*/
                             a=   3   4   5
                             b=   4   3   5      /*(positive numbers don't need quotes.)*/
                             c= "-5 -12 -13"
call tellV  'vector A =', a                      /*show the  A  vector, aligned numbers.*/
call tellV  'vector B =', b                      /*  "   "   B     "        "      "    */
call tellV  'vector C =', c                      /*  "   "   C     "        "      "    */
     say
call tellV  '  dot product [A∙B] =',                 dot(a, b)
call tellV  'cross product [AxB] =',               cross(a, b)
call tellV  'scalar triple product [A∙(BxC)] =',     dot(a, cross(b, c) )
call tellV  'vector triple product [Ax(BxC)] =',   cross(a, cross(b, c) )
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
cross: procedure; arg $1 $2 $3,@1 @2 @3;  return  $2*@3 -$3*@2  $3*@1 -$1*@3  $1*@2 -$2*@1
dot:   procedure; arg $1 $2 $3,@1 @2 @3;  return  $1*@1        +   $2*@2     +   $3*@3
/*──────────────────────────────────────────────────────────────────────────────────────*/
tellV: procedure; parse arg name,x y z;   w=max(4,length(x),length(y),length(z)) /*max W*/
       say right(name,40)  right(x,w)  right(y,w)  right(z,w); /*show vector.*/    return
