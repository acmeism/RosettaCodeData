/*REXX program demonstrates first─class functions (as a list of the names of functions).*/
A = 'd2x   square   sin    cos'                  /*a list of  functions  to demonstrate.*/
B = 'x2d   sqrt     Asin   Acos'                 /*the inverse functions of above list. */
w=digits()                                       /*W:  width of numbers to be displayed.*/
                                                 /* [↓]  collection of  A & B  functions*/
     do j=1  for words(A);      say;       say   /*step through the list;  2 blank lines*/
     say center("number",w)     center('function', 3*w+1)     center("inverse", 4*w)
     say copies("─"     ,w)     copies("─",        3*w+1)     copies("─",       4*w)
     if j<2   then call test j, 20  60   500     /*functions  X2D, D2X:  integers only. */
              else call test j, 0  0.5  1  2     /*all other functions:  floating point.*/
     end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Acos:    procedure; parse arg x; if x<-1|x>1  then call AcosErr;    return .5*pi()-Asin(x)
r2r:     return arg(1) // (pi()*2)               /*normalize radians ──► 1 unit circle*/
square:  return arg(1) ** 2
pi:      pi=3.14159265358979323846264338327950288419716939937510582097494459230; return pi
tellErr: say;   say '*** error! ***';  say;  say arg(1);  say;  exit 13
tanErr:  call tellErr 'tan(' || x") causes division by zero, X="             ||  x
AsinErr: call tellErr 'Asin(x),  X  must be in the range of  -1 ──► +1,  X=' ||  x
AcosErr: call tellErr 'Acos(x),  X  must be in the range of  -1 ──► +1,  X=' ||  x
/*──────────────────────────────────────────────────────────────────────────────────────*/
Asin:    procedure; parse arg x;  if x<-1 | x>1  then call AsinErr;   s=x*x
             if abs(x)>=.7  then return sign(x)*Acos(sqrt(1-s));      z=x;  o=x;  p=z
                      do j=2 by 2; o=o*s*(j-1)/j; z=z+o/(j+1); if z=p then leave; p=z; end
             return z
/*──────────────────────────────────────────────────────────────────────────────────────*/
cos:     procedure; parse arg x;   x=r2r(x);          a=abs(x);         Hpi=pi*.5
             numeric fuzz min(6,digits()-3);          if a=pi()    then return -1
             if a=Hpi | a=Hpi*3  then return  0 ;     if a=pi()/3  then return .5
             if a=pi()*2/3       then return -.5;                  return .sinCos(1,1,-1)
/*──────────────────────────────────────────────────────────────────────────────────────*/
sin:     procedure; parse arg x;   x=r2r(x);          numeric fuzz min(5, digits()-3)
             if abs(x)=pi()  then return 0;                        return .sinCos(x,x,1)
/*──────────────────────────────────────────────────────────────────────────────────────*/
.sinCos: parse arg z 1 p,_,i;  x=x*x
             do k=2  by 2; _=-_*x/(k*(k+i)); z=z+_; if z=p  then leave; p=z; end; return z
/*──────────────────────────────────────────────────────────────────────────────────────*/
invoke:  parse arg fn,v;  q='"';  if datatype(v,"N")  then q=
             _=fn || '('q || v || q")";          interpret 'func='_;           return func
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt:    procedure; parse arg x;  if x=0  then return 0;  d=digits();  m.=9;  numeric form
         numeric digits; parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;  g=g*.5'e'_%2
         h=d+6;     do j=0  while h>9;      m.j=h;               h=h%2+1;        end /*j*/
                    do k=j+5  to 0  by -1;  numeric digits m.k;  g=(g+x/g)*.5;   end /*k*/
         numeric digits d;                  return g/1
/*──────────────────────────────────────────────────────────────────────────────────────*/
test:    procedure expose A B w;  parse arg fu,xList;     d=digits() /*xList:  numbers. */
                 do k=1  for words(xList);          x=word(xList, k)
                 numeric digits d+5                                  /*higher precision.*/
                 fun=word(A, fu);  funV=invoke(fun, x)   ;  fun@=_
                 inv=word(B, fu);  invV=invoke(inv, funV);  inv@=_
                 numeric digits d                                    /*restore precision*/
                 if datatype(funV, 'N')  then funV=funV/1            /*round to digits()*/
                 if datatype(invV, 'N')  then invV=invV/1            /*round to digits()*/
                 say center(x, w)   right(fun@, 2*w)'='left(left('', funV>=0)funV, w),
                                    right(inv@, 3*w)'='left(left('', invV>=0)invV, w)
                 end   /*k*/
         return
