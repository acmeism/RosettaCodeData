PROC fibonacci = ( INT x )INT:
     IF x < 0
     THEN
         print( ( "negative parameter to fibonacci", newline ) );
         stop
     ELSE
         PROC actual fibonacci = ( INT n )INT:
             IF n < 2
             THEN
                 n
             ELSE
                 actual fibonacci( n - 1 ) + actual fibonacci( n - 2 )
             FI;
         actual fibonacci( x )
     FI;
