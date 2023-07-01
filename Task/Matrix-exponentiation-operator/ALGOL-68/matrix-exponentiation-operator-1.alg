INT default upb=3;
MODE VEC = [default upb]COSCAL;
MODE MAT = [default upb,default upb]COSCAL;

OP * = (VEC a,b)COSCAL: (
    COSCAL result:=0;
    FOR i FROM LWB a TO UPB a DO result+:= a[i]*b[i] OD;
    result
  );

OP * = (VEC a, MAT b)VEC: ( # overload vec times matrix #
    [2 LWB b:2 UPB b]COSCAL result;
    FOR j FROM 2 LWB b TO 2 UPB b DO result[j]:=a*b[,j] OD;
    result
  );

OP * = (MAT a, b)MAT: ( # overload matrix times matrix #
    [LWB a:UPB a, 2 LWB b:2 UPB b]COSCAL result;
    FOR k FROM LWB result TO UPB result DO result[k,]:=a[k,]*b OD;
    result
  );

OP IDENTITY = (INT upb)MAT:(
  [upb,upb] COSCAL out;
  FOR i TO upb DO
    FOR j TO upb DO
      out[i,j]:= ( i=j |1|0)
    OD
  OD;
  out
);
