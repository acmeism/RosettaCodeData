IF  # create an executable to run a program with Algol 68G                   #
    # a C program is created that writes the source to a temporary file and  #
    # then calls a the Algol 68G interpreter to run it                       #

    # get the temporary file path, the path to the interpreter, the source   #
    # file and the path for the generated C source                           #
    STRING temp file path, algol 68g path, a68 source, c source;
    print( ( "Temporary file path                      (target system) : " ) );
    read( ( temp file path, newline ) );
    print( ( "Command to run the Algol 68G interpreter (target system) : " ) );
    read( ( algol 68g path, newline ) );
    print( ( "Algol 68 source                            (this system) : " ) );
    read( ( a68 source, newline ) );
    print( ( "C source to generate                       (this system) : " ) );
    read( ( c source, newline ) );

    FILE input source file, output source file;

    open( input source file, a68 source, stand in channel ) /= 0
THEN
    # failed to open the Algol 68 source file                                #
    print( (  "Unable to open """ + a68 source + """", newline ) )
ELIF IF open( output source file, c source, stand out channel ) = 0
     THEN
         # opened OK - file already exists and will be overwritten           #
         FALSE
     ELSE
         # failed to open the file - try creating a new file                 #
         establish( output source file, c source, stand out channel ) /= 0
     FI
THEN
    # failed to open the C source file                                       #
    print( ( "Unable to open """ + c source + """", newline ) );
    close( input source file )
ELSE
    # files opened OK                                                        #

    # returns line with any " or \ characters preceded by \                  #
    PROC add escapes = ( STRING line )STRING:
         BEGIN
            [ 1 : ( ( UPB line + 1 ) - LWB line ) * 2 ]CHAR output line;
            INT o pos := 0;
            FOR l pos FROM LWB line TO UPB line DO
                CHAR c = line[ l pos ];
                IF c = "\" OR c = """" THEN
                    # must escape this character in C                        #
                    output line[ o pos +:= 1 ] := "\"
                FI;
                output line[ o pos +:= 1 ] := c
            OD;
            output line[ 1 : o pos ]
         END # add escapes # ;

    # writes line to the output source file                                  #
    PROC emit = ( STRING line )VOID:
         put( output source file, ( line, newline ) );

    BOOL at eof := FALSE;
    # set the EOF handler for the input file                                 #
    on logical file end( input source file
                       , ( REF FILE f )BOOL:
                           BEGIN
                               # note that we reached EOF on the latest read #
                               at eof := TRUE;
                               # return TRUE so processing can continue      #
                               TRUE
                           END
                         );

    # include headers, output routine and the start of the main routine      #
    emit( "#include <stdio.h>" );
    emit( "#include <errno.h>" );
    emit( "static void w( char * line, FILE * tf )" );
    emit( "{fputs( line, tf );" );
    emit( " if( errno != 0 ){ perror( ""temp"" );exit( 2 ); }" );
    emit( "}" );
    emit( "int main( int argc, char ** argv )" );
    emit( "{FILE * tf = fopen( """
        + add escapes( temp file path )
        + """, ""w"" );"
        );
    emit( " if( tf == NULL ){ perror( ""temp"" );exit( 1 ); }" );
    # output code to write the Algol 68 source to the temporary file         #
    WHILE STRING line;
          get( input source file, ( line, newline ) );
          NOT at eof
    DO
        IF line /= "" THEN
            # line is not empty                                              #
            emit( " w( """ + add escapes( line ) + "\n"", tf );" )
        FI
    OD;
    close( input source file );
    # code to close the temporary file and interpret it then delete it       #
    emit( " fclose( tf );" );
    emit( " system( """
        + add escapes( algol 68g path )
        + " "
        + add escapes( temp file path )
        + """ );"
        );
    emit( " remove( """ + add escapes( temp file path ) + """ );" );
    emit( "}" );
    close( output source file );

    print( ( newline
           , c source
           , " generated"
           , newline
           , "This can now be compiled for the target system "
           , "(possibly via cross-compilation)"
           , newline
           , "using a suitable C compiler"
           , newline
           )
         )
FI
