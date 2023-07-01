BEGIN
  INT iterations = 300000;
  LONG REAL scale x = 40, scale y = 40;
  [0:400,-200:200]CHAR canvas;

  LONG REAL x := 0, y := 0;

  FOR i FROM 1 LWB canvas TO 1 UPB canvas DO
    FOR j FROM 2 LWB canvas TO 2 UPB canvas DO
      canvas[i,j] := "0"
  OD OD;

  canvas[0, 0] := "1";
  TO iterations DO
    REAL choice := random;
    LONG REAL xn = x, yn = y;

    IF choice < 0.01 THEN
      x := 0;
      y := 0.16 * yn
    ELIF (choice -:= 0.01) < 0.85 THEN
      x :=  0.85 * xn + 0.04 * yn;
      y := -0.04 * xn + 0.85 * yn + 1.6
    ELIF (choice -:= 0.85) < 0.07 THEN
      x := 0.2  * xn - 0.26 * yn;
      y := 0.23 * xn + 0.22 * yn + 1.6
    ELSE
      x := -0.15 * xn + 0.28 * yn;
      y :=  0.26 * xn + 0.24 * yn + 0.44
    FI;

    INT px = SHORTEN ROUND (x * scale x),
        py = SHORTEN ROUND (y * scale y);
    IF px < 2 LWB canvas OR px > 2 UPB canvas OR
       py < 1 LWB canvas OR py > 1 UPB canvas
    THEN
      print(("resize canvas. px=", px, ", py=", py, new line));
      leave
    FI;

    canvas[py, px] := "1"
  OD;

  FILE f;
  IF establish(f, "fern.pbm", stand out channel) /= 0 THEN
    print("error creating file!"); leave
  FI;
  put(f, "P1"); new line(f);
  put(f, (whole((2 UPB canvas) - (2 LWB canvas) + 1, 0), " ",
          whole((1 UPB canvas) - (1 LWB canvas) + 1, 0), new line));
  FOR i FROM 1 UPB canvas BY -1 TO 1 LWB canvas DO
    put(f, canvas[i,]); new line(f)
  OD;
  close(f);
  leave: SKIP
END
