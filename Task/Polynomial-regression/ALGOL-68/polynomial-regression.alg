MODE FIELD = REAL;

MODE
  VEC = [0]FIELD,
  MAT = [0,0]FIELD;

PROC VOID raise index error := VOID: (
  print(("stop", new line));
  stop
);

COMMENT from http://rosettacode.org/wiki/Matrix_Transpose#ALGOL_68 END COMMENT
OP ZIP = ([,]FIELD in)[,]FIELD:(
  [2 LWB in:2 UPB in,1 LWB in:1UPB in]FIELD out;
  FOR i FROM LWB in TO UPB in DO
     out[,i]:=in[i,]
  OD;
  out
);

COMMENT from http://rosettacode.org/wiki/Matrix_multiplication#ALGOL_68 END COMMENT
OP * = (VEC a,b)FIELD: ( # basically the dot product #
    FIELD result:=0;
    IF LWB a/=LWB b OR UPB a/=UPB b THEN raise index error FI;
    FOR i FROM LWB a TO UPB a DO result+:= a[i]*b[i] OD;
    result
  );

OP * = (VEC a, MAT b)VEC: ( # overload vector times matrix #
    [2 LWB b:2 UPB b]FIELD result;
    IF LWB a/=LWB b OR UPB a/=UPB b THEN raise index error FI;
    FOR j FROM 2 LWB b TO 2 UPB b DO result[j]:=a*b[,j] OD;
    result
  );

OP * = (MAT a, b)MAT: ( # overload matrix times matrix #
     [LWB a:UPB a, 2 LWB b:2 UPB b]FIELD result;
     IF 2 LWB a/=LWB b OR 2 UPB a/=UPB b THEN raise index error FI;
     FOR k FROM LWB result TO UPB result DO result[k,]:=a[k,]*b OD;
     result
   );

COMMENT from http://rosettacode.org/wiki/Pyramid_of_numbers#ALGOL_68 END COMMENT
OP / = (VEC a, MAT b)VEC: ( # vector division #
  [LWB a:UPB a,1]FIELD transpose a;
  transpose a[,1]:=a;
  (transpose a/b)[,1]
);

OP / = (MAT a, MAT b)MAT:( # matrix division #
  [LWB b:UPB b]INT p ;
  INT sign;
  [,]FIELD lu = lu decomp(b, p, sign);
  [LWB a:UPB a, 2 LWB a:2 UPB a]FIELD out;
  FOR col FROM 2 LWB a TO 2 UPB a DO
    out[,col] := lu solve(b, lu, p, a[,col]) [@LWB out[,col]]
  OD;
  out
);

FORMAT int repr = $g(0)$,
       real repr = $g(-7,4)$;

PROC fit =  (VEC x, y, INT order)VEC:
BEGIN
   [0:order, LWB x:UPB x]FIELD a;  # the plane #
   FOR i FROM 2 LWB a TO 2 UPB a  DO
      FOR j FROM LWB a TO UPB a DO
         a [j, i] := x [i]**j
      OD
   OD;
   ( y * ZIP a ) / ( a * ZIP a )
END # fit #;

PROC print polynomial = (VEC x)VOID: (
   BOOL empty := TRUE;
   FOR i FROM UPB x BY -1 TO LWB x DO
     IF x[i] NE 0 THEN
       IF x[i] > 0 AND NOT empty THEN print ("+") FI;
       empty := FALSE;
       IF x[i] NE 1 OR i=0 THEN
         IF ENTIER x[i] = x[i] THEN
           printf((int repr, x[i]))
         ELSE
           printf((real repr, x[i]))
         FI
       FI;
       CASE i+1 IN
         SKIP,print(("x"))
       OUT
         printf(($"x**"g(0)$,i))
       ESAC
     FI
   OD;
   IF empty THEN print("0") FI;
   print(new line)
);

fitting: BEGIN
   VEC c =
          fit
          (  (0.0, 1.0,  2.0,  3.0,  4.0,  5.0,   6.0,   7.0,   8.0,   9.0,  10.0),
             (1.0, 6.0, 17.0, 34.0, 57.0, 86.0, 121.0, 162.0, 209.0, 262.0, 321.0),
             2
          );
   print polynomial(c);
   VEC d =
          fit
          ( (0, 1, 2, 3, 4, 5, 6, 7, 8, 9),
            (2.7, 2.8, 31.4, 38.1, 58.0, 76.2, 100.5, 130.0, 149.3, 180.0),
            2
          );
   print polynomial(d)
END # fitting #
