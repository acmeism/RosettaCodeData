BEGIN
  PROC writedat = (STRING filename, []REAL x, y, INT x width, y width)VOID: (
    IF   FILE f;
         INT open code = IF open( f, filename, stand out channel ) = 0
                         THEN # opened OK - file already exists and     #
                              #             will be overwritten         #
                              0
                         ELSE # failed to open the file                 #
                              # - try creating a new file               #
                              establish( f, filename, stand out channel )
                         FI;
         open code NE 0
    THEN print( ( "Unable to open ", filename, " on standout: ", open code, newline ) ); stop
    ELSE FOR i TO UPB x DO
            # FORMAT := IF the absolute exponent is small enough, THEN use fixed ELSE use float FI; #
            PROC fmt = (REAL v, INT v width)STRING:
                 ( ABS log(v)<v width | fixed(v,-v width,v width-2) | float(v,-v width,v width-4,-1) );
            put(f,(fmt(x[i], x width), " ", fmt(y[i], y width), newline))
         OD;
         close(f)
    FI
  );
  # Example usage: #
  (
    []REAL x = (1, 2, 3, 1e11);
    [UPB x]REAL y; FOR i TO UPB x DO y[i]:=sqrt(x[i]) OD;
    print(("x before:"));FOR i TO UPB x DO print((" ",x[i])) OD;print((newline));
    print(("y before:"));FOR i TO UPB y DO print((" ",y[i])) OD;print((newline));
    writedat("sqrt.dat", x, y, 3+2, 5+2);

    print(("After:",newline));
    FILE sqrt dat;
    IF   INT open code = open(sqrt dat, "sqrt.dat", stand in channel);
         open code NE 0
    THEN print( ( "unable to open sqrt.dat on stand in: ", open code, newline ) ); stop
    ELSE on logical file end(sqrt dat, (REF FILE f)BOOL: stop);
         TO UPB x DO
            STRING line;
            get(sqrt dat, (line, new line));
            print((line,new line))
         OD
    FI
  )
END
