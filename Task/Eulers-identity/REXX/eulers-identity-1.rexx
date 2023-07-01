/*REXX program proves  Euler's  identity by showing that:      e^(i pi) + 1  ≡     0    */
numeric digits length( pi() )  -  length(.)      /*define pi;  set # dec. digs precision*/
        cosPI= fmt( cos(pi) )                    /*calculate the value of   cos(pi).    */
        sinPI= fmt( sin(pi) )                    /*    "      "    "    "   sin(pi).    */
say  '         cos(pi) = '  cosPI                /*display    "    "    "   cos(Pi).    */
say  '         sin(pi) = '  sinPI                /*   "       "    "    "   sin(Pi).    */
say                                              /*separate the wheat from the chaff.   */
     $= cosPI  +  mult( sqrt(-1), sinPI )  +  1  /*calc. product of sin(x) and sqrt(-1).*/
say  '    e^(i pi) + 1 = '  fmt($)    '    ' word("unproven proven",  ($=0)  +  1)
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
fmt:   procedure; parse arg x; x= format(x, , digits() %2, 0);   return left('', x>=0)x /1
mult:  procedure; parse arg a,b;       if a=0  | b=0  then return 0;            return a*b
pi:    pi= 3.1415926535897932384626433832795028841971693993751058209749445923;  return pi
cos:   procedure; parse arg x;  z= 1;  _= 1;   q= x*x;  i= -1;            return .sinCos()
sin:   procedure; parse arg x 1 z 1 _;         q= x*x;  i=  1;            return .sinCos()
.sinCos:   do k=2  by 2  until p=z;  p=z;  _= -_ * q/(k*(k+i));  z= z+_;  end;    return z
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt:  procedure; parse arg x;  if x=0  then return 0;  d=digits(); i=;             h= d+6
       numeric digits;  numeric form;   if x<0  then  do;  x= -x;   i= 'i';  end;   m.= 9
       parse value format(x, 2, 1, , 0)  'E0'   with   g  'E'  _  .;     g= g * .5'e'_ % 2
         do j=0  while h>9;      m.j= h;              h= h % 2   + 1;  end
         do k=j+5  to 0  by -1;  numeric digits m.k;  g= (g+x/g) *.5;  end;  return g || i
