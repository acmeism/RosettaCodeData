IF  FILE   output;
    STRING output file name = "output.txt";
    open( output, output file name, stand out channel ) = 0
THEN
    # file opened OK #
    put( output, ( "line 1", newline, "line 2", newline ) );
    close( output )
ELSE
    # unable to open the output file #
    print( ( "Cannot open ", output file name, newline ) )
FI
