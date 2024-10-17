# Calculate the Feigenbaum constant #

print( ( "Feigenbaum constant calculation:", newline ) );
INT max it   = 13;
INT max it j = 10;
REAL a1 := 1.0;
REAL a2 := 0.0;
REAL d1 := 3.2;
print( ( "i  ", "d", newline ) );
FOR i FROM 2 TO max it DO
     REAL a := a1 + (a1 - a2) / d1;
     TO max it j DO
          REAL x := 0;
          REAL y := 0;
          TO 2 ^ i DO
               y := 1 - 2 * y * x;
               x := a - x * x
          OD;
          a := a - x / y
     OD;
     REAL d = (a1 - a2) / (a - a1);
     IF i < 10 THEN
        print( ( whole( i, 0 ), "  ", fixed( d, -10, 8 ), newline ) )
     ELSE
        print( ( whole( i, 0 ), " ",  fixed( d, -10, 8 ), newline ) )
     FI;
     d1 := d;
     a2 := a1;
     a1 := a
OD
