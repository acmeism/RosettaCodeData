main:(

  [,]REAL m=((1,  1,  1,   1),
             (2,  4,  8,  16),
             (3,  9, 27,  81),
             (4, 16, 64, 256),
             (5, 25,125, 625));

  OP ZIP = ([,]REAL in)[,]REAL:(
    [2 LWB in:2 UPB in,1 LWB in:1UPB in]REAL out;
    FOR i FROM LWB in TO UPB in DO
       out[,i]:=in[i,]
    OD;
    out
  );

  PROC pprint = ([,]REAL m)VOID:(
    FORMAT real fmt = $g(-6,2)$; # width of 6, with no '+' sign, 2 decimals #
     FORMAT vec fmt = $"("n(2 UPB m-1)(f(real fmt)",")f(real fmt)")"$;
    FORMAT matrix fmt = $x"("n(UPB m-1)(f(vec fmt)","lxx)f(vec fmt)");"$;
    # finally print the result #
    printf((matrix fmt,m))
  );

  printf(($x"Transpose:"l$));
  pprint((ZIP m))
)
