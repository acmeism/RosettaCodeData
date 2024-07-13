/*REXX program computes the products: dot, cross, scalar triple, and vector triple.*/
a=   3   4   5
b=   4   3   5                        /*(positive numbers don't need quotes.)*/
c= '-5 -12 -13'
Call tellV 'vector A =', a            /*show the  A  vector, aligned numbers.*/
Call tellV "vector B =", b            /*  "   "   B     "        "      "    */
Call tellV "vector C =", c            /*  "   "   C     "        "      "    */
Say ''
Call tellV '  dot product [A·B] =',             dot(a,b)
Call tellV 'cross product [AxB] =',             cross(a,b)
Call tellV 'scalar triple product [A·(BxC)] =', dot(a,cross(b,c))
Call tellV 'vector triple product [Ax(BxC)] =', cross(a,cross(b,c))
Exit                                   /*stick a fork in it, we're all done. */
/*---------------------------------------------------------------------------*/
cross: Procedure
  Arg a b c, u v w
  Return b*w-c*v c*u-a*w a*v-b*u
dot: Procedure
  Arg a b c, u v w
  Return a*u + b*v + c*w
/*---------------------------------------------------------------------------*/
tellV: Procedure
  Parse Arg name,x y z
  w=max(4,length(x),length(y),length(z))                 /*max width         */
  Say right(name,33) right(x,w) right(y,w) right(z,w)    /*show vector.      */
  Return
