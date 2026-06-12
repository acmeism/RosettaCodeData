/*REXX program calculates Particle Swarm Optimization as it migrates through a solution.*/
numeric digits length( pi() )   -  length(.)     /*use the number of decimal digs in pi.*/
parse arg  x  y  d  #part  sDigs  .              /*obtain optional arguments from the CL*/
if     x==''  |     x==","  then     x=   -0.5   /*Not specified?  Then use the default.*/
if     y==''  |     y==","  then     y=   -1.5   /* "      "         "   "   "     "    */
if     d==''  |     d==","  then     d=    1     /* "      "         "   "   "     "    */
if #part==''  | #part==","  then #part= 1e12     /* "      "         "   "   "     "    */
if sDigs==''  | sDigs==","  then sDigs=   25     /* "      "         "   "   "     "    */
old=                                             /*#part:   1e12  ≡  is one trillion.   */
minF= #part                                      /*the minimum for the function (#part).*/
show= sDigs + 3                                  /*adjust number decimal digits for show*/
say "══iteration══"   center('X',show,"═")    center('Y',show,"═")    center('D',show,"═")
#= 0;                call refine    x,    y      /*#: REFINE iterations; invoke REFINE. */
                do  until refine(minX, minY)     /*perform until the mix is  "refined". */
                d=d  * .2                        /*decrease the difference in the mix. .*/
                end   /*until*/                  /* [↑]  stop refining if no difference.*/
$= 15 + show*2;                          say     /*compute the indentation for alignment*/
say right('The global minimum for  f(-.54719, -1.54719)  ───► ', $)    fmt(f(-.54719, -1.54719))
say right('The published global minimum is:'                   , $)    fmt(  -1.9133           )
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
refine: parse arg xx,yy;                           h= d * .5      /*compute ½ distance. */
                  do   x=xx-d  to xx+d  by h
                    do y=yy-d  to yy+d  by h;      f= f(x, y);   if f>=minF  then iterate
                    new= fmt(x)   fmt(y)   fmt(f);               if new=old  then return 1
                    #= # + 1;     say center(#,13) new            /*bump iter.; show new*/
                    minF= f;    minX= x;     minY= y;    old= new /*assign new values.  */
                    end   /*y*/
                  end     /*x*/
        return 0
/*──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────*/
f:   procedure:  parse arg a,b;                     return  sin(a+b)  +  (a-b)**2  -  1.5*a  +  2.5*b  +  1
fmt: ?= format(arg(1), , sDigs);   L= length(?);    if pos(., ?)\==0  then ?= strip( strip(?, 'T', 0), "T", .);   return left(?,L)
pi:  pi=3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865; return pi
r2r: return arg(1) // ( pi() * 2)                                       /*normalize radians  ───►  a unit circle.*/
sin: procedure; arg x; x= r2r(x);  z=x;  xx= x*x;   do k=2  by 2  until p=z;  p=z;  x= -x* xx/ (k*(k+1));  z= z+x;  end;  return z
