PROC raise exception = ([]STRING msg)VOID: ( putf(stand error,("Exception:", $" "g$, msg, $l$)); stop );

# The MODE of lx and ly here should really be a UNION of "something REAL",
"something COMPLex", and "something SYMBOLIC" ... #

PROC thiele=([]REAL lx,ly, REAL x) REAL:
BEGIN
  []REAL xx=lx[@1],yy=ly[@1];
  INT n=UPB xx;
  IF UPB yy=n THEN
# Assuming that the values of xx are distinct ... #
    [0:n-1,1:n]REAL p;
    p[0,]:=yy[];
    FOR i TO n-1 DO p[1,i]:=(xx[i]-xx[1+i])/(p[0,i]-p[0,1+i]) OD;
    FOR i FROM 2 TO n-1 DO
      FOR j TO n-i DO
        p[i,j]:=(xx[j]-xx[j+i])/(p[i-1,j]-p[i-1,j+1])+p[i-2,j+1]
      OD
    OD;
    REAL a:=0;
    FOR i FROM n-1 BY -1 TO 2 DO a:=(x-xx[i])/(p[i,1]-p[i-2,1]+a) OD;
    yy[1]+(x-xx[1])/(p[1,1]+a)
  ELSE
    raise exception(("Unequal length arrays supplied: ",whole(UPB xx,0)," NE ",whole(UPB yy,0))); SKIP
  FI
END;

test:(
  FORMAT real fmt = $g(0,real width-2)$;

  REAL lwb x=0, upb x=1.55, delta x = 0.05;

  [0:ENTIER ((upb x-lwb x)/delta x)]STRUCT(REAL x, sin x, cos x, tan x) trig table;

  PROC init trig table = VOID:
    FOR i FROM LWB trig table TO UPB trig table DO
      REAL x = lwb x+i*delta x;
      trig table[i]:=(x, sin(x), cos(x), tan(x))
    OD;

  init trig table;

# Curry the thiele function to create matching inverse trigonometric functions #
  PROC (REAL)REAL inv sin = thiele(sin x OF trig table, x OF trig table,),
                  inv cos = thiele(cos x OF trig table, x OF trig table,),
                  inv tan = thiele(tan x OF trig table, x OF trig table,);

  printf(($"pi estimate using "g" interpolation: "f(real fmt)l$,
    "sin", 6*inv sin(1/2),
    "cos", 3*inv cos(1/2),
    "tan", 4*inv tan(1)
  ))
)
