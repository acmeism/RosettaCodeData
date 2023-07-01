# applies fn to successive elements of the array of values #
# the result is 0 if there are no values                   #
PROC reduce = ( []INT values, PROC( INT, INT )INT fn )INT:
     IF UPB values < LWB values
     THEN # no elements #
          0
     ELSE # there are some elements #
          INT result := values[ LWB values ];
          FOR pos FROM LWB values + 1 TO UPB values
          DO
              result := fn( result, values[ pos ] )
          OD;
          result
     FI; # reduce #

# test the reduce procedure #
BEGIN print( ( reduce( ( 1, 2, 3, 4, 5 ), ( INT a, b )INT: a + b ), newline ) ) # sum #
    ; print( ( reduce( ( 1, 2, 3, 4, 5 ), ( INT a, b )INT: a * b ), newline ) ) # product #
    ; print( ( reduce( ( 1, 2, 3, 4, 5 ), ( INT a, b )INT: a - b ), newline ) ) # difference #
END
