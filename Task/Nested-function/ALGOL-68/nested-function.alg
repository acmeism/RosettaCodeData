PROC make list = ( STRING separator )STRING:
     BEGIN
        INT counter := 0;
        PROC make item = ( STRING item )STRING:
             BEGIN
                counter +:= 1;
                whole( counter, 0 ) + separator + item + REPR 10
             END; # make item #
        make item( "first" ) + make item( "second" ) + make item( "third" )
     END; # make list #

print( ( make list( ". " ) ) )
