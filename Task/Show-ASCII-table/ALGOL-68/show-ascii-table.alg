# generate an ascii table for characters 32 - 127 #
FOR c FROM 32 TO 32 + 15 DO
    FOR ach FROM c BY 16 TO c + ( 16 * 5 ) DO
        print( ( whole( ach, -4 )
               , ": "
               , IF   ach =  32 THEN "SPC"
                 ELIF ach = 127 THEN "DEL"
                 ELSE " " + REPR ach + " "
                 FI
               )
             )
    OD;
    print( ( newline ) )
OD
