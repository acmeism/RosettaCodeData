# returns an array of the first required count elements of an a n-step fibonacci sequence #
# the initial values are taken from the init array                                        #
PROC n step fibonacci sequence = ( []INT init, INT required count )[]INT:
     BEGIN
         [ 1 : required count ]INT result;
         []INT initial values = init[ AT 1 ];
         INT step             = UPB initial values;
         # install the initial values                                                     #
         FOR n TO step DO result[ n ] := initial values[ n ] OD;
         # calculate the rest of the sequence                                             #
         FOR n FROM step + 1 TO required count DO
             result[ n ] := 0;
             FOR p FROM n - step TO n - 1 DO result[ n ] +:= result[ p ] OD
         OD;
         result
     END; # required count #

# prints the elements of a sequence                                                       #
PROC print sequence = ( STRING legend, []INT sequence )VOID:
     BEGIN
        print( ( legend, ":" ) );
        FOR e FROM LWB sequence TO UPB sequence DO print( ( " ", whole( sequence[ e ], 0 ) ) ) OD;
        print( ( newline ) )
     END; # print sequence #

# print some sequences                                                                    #
print sequence( "fibonacci   ", n step fibonacci sequence( ( 1, 1 ),       10 ) );
print sequence( "tribonacci  ", n step fibonacci sequence( ( 1, 1, 2 ),    10 ) );
print sequence( "tetrabonacci", n step fibonacci sequence( ( 1, 1, 2, 4 ), 10 ) );
print sequence( "lucus       ", n step fibonacci sequence( ( 2, 1 ),       10 ) )
