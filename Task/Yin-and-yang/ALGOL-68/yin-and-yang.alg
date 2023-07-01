INT scale x=2, scale y=1;
CHAR black="#", white=".", clear=" ";

PROC print yin yang = (REAL radius)VOID:(

  PROC in circle = (REAL centre x, centre y, radius, x, y)BOOL:
    (x-centre x)**2+(y-centre y)**2 <= radius**2;

  PROC (REAL, REAL)BOOL
    in big circle = in circle(0, 0, radius, , ),
    in white semi circle  = in circle(0, +radius/2, radius/2, , ),
    in small black circle = in circle(0, +radius/2, radius/6, , ),
    in black semi circle  = in circle(0, -radius/2, radius/2, , ),
    in small white circle = in circle(0, -radius/2, radius/6, , );

  FOR sy FROM +ROUND(radius * scale y) BY -1 TO -ROUND(radius * scale y) DO
    FOR sx FROM -ROUND(radius * scale x) TO +ROUND(radius * scale x) DO
      REAL x=sx/scale x, y=sy/scale y;
      print(
        IF in big circle(x, y) THEN
            IF in white semi circle(x, y) THEN
              IF in small black circle(x, y) THEN black ELSE white FI
            ELIF in black semi circle(x, y) THEN
              IF in small white circle(x, y) THEN white ELSE black FI
            ELIF x < 0 THEN white ELSE black FI
        ELSE
          clear
        FI
      )
    OD;
    print(new line)
  OD
);

main:(
  print yin yang(17);
  print yin yang(8)
)
