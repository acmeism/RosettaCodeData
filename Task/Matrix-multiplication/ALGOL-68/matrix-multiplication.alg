MODE FIELD = LONG REAL; # field type is LONG REAL #
INT default upb:=3;
MODE VECTOR = [default upb]FIELD;
MODE MATRIX = [default upb,default upb]FIELD;

# crude exception handling #
PROC VOID raise index error := VOID: GOTO exception index error;

# define the vector/matrix operators #
OP * = (VECTOR a,b)FIELD: ( # basically the dot product #
    FIELD result:=0;
    IF LWB a/=LWB b OR UPB a/=UPB b THEN raise index error FI;
    FOR i FROM LWB a TO UPB a DO result+:= a[i]*b[i] OD;
    result
  );

 OP * = (VECTOR a, MATRIX b)VECTOR: ( # overload vector times matrix #
    [2 LWB b:2 UPB b]FIELD result;
    IF LWB a/=LWB b OR UPB a/=UPB b THEN raise index error FI;
    FOR j FROM 2 LWB b TO 2 UPB b DO result[j]:=a*b[,j] OD;
    result
  );
# this is the task portion #
OP * = (MATRIX a, b)MATRIX: ( # overload matrix times matrix #
    [LWB a:UPB a, 2 LWB b:2 UPB b]FIELD result;
    IF 2 LWB a/=LWB b OR 2 UPB a/=UPB b THEN raise index error FI;
    FOR k FROM LWB result TO UPB result DO result[k,]:=a[k,]*b OD;
    result
  );

 # Some sample matrices to test #
test:(
  MATRIX a=((1,  1,  1,   1), # matrix A #
            (2,  4,  8,  16),
            (3,  9, 27,  81),
            (4, 16, 64, 256));

  MATRIX b=((  4  , -3  ,  4/3,  -1/4 ), # matrix B #
            (-13/3, 19/4, -7/3,  11/24),
            (  3/2, -2  ,  7/6,  -1/4 ),
            ( -1/6,  1/4, -1/6,   1/24));

  MATRIX prod = a * b; # actual multiplication example of A x B #

  FORMAT real fmt = $g(-6,2)$; # width of 6, with no '+' sign, 2 decimals #
  PROC real matrix printf= (FORMAT real fmt, MATRIX m)VOID:(
    FORMAT vector fmt = $"("n(2 UPB m-1)(f(real fmt)",")f(real fmt)")"$;
    FORMAT matrix fmt = $x"("n(UPB m-1)(f(vector fmt)","lxx)f(vector fmt)");"$;
    # finally print the result #
    printf((matrix fmt,m))
  );

  # finally print the result #
  print(("Product of a and b: ",new line));
  real matrix printf(real fmt, prod)
  EXIT

  exception index error:
    putf(stand error, $x"Exception: index error."l$)
)
