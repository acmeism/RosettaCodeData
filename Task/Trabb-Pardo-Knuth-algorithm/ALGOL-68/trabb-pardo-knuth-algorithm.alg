[ 0 : 10 ]REAL a;
PROC f = ( REAL t )REAL:
    sqrt(ABS t)+5*t*t*t;
FOR i FROM LWB a TO UPB a DO read( ( a[ i ] ) ) OD;
FOR i FROM UPB a BY -1 TO LWB a DO
       REAL y=f(a[i]);
       IF y > 400 THEN print( ( "TOO LARGE", newline ) )
                  ELSE print( ( fixed( y, -9, 4 ), newline ) )
       FI
OD
