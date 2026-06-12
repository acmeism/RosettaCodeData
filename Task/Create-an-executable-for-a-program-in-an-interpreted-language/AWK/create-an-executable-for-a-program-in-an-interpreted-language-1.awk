# create an executable to run a program with awk
# a C program is created that writes the source to a temporary file and
# then calls a the Awk interpreter to run it

BEGIN \
{

    FALSE = 0;
    TRUE  = 1;

    # get the temporary file path, the path to the interpreter, the source
    # file and the path for the generated C source

    printf( "Temporary file path                (target system) : " );
    getline tempPath;
    printf( "Command to run the Awk interpreter (target system) : " );
    getline awkInterpreter;
    printf( "Awk source                           (this system) : " );
    getline awkSource;
    printf( "C source to generate                 (this system) : " );
    getline cSource;

    atEof   = FALSE;
    ioError = FALSE;

    # include headers, output routine and the start of the main routine

    printf( "" ) > cSource;

    emit( "#include <stdio.h>" );
    emit( "#include <errno.h>" );
    emit( "static void w( char * line, FILE * tf )" );
    emit( "{fputs( line, tf );" );
    emit( " if( errno != 0 ){ perror( \"temp\" );exit( 2 ); }" );
    emit( "}" );
    emit( "int main( int argc, char ** argv )" );
    emit( "{FILE * tf = fopen( \"" addEscapes( tempPath ) "\", \"w\" );" );
    emit( " if( tf == NULL ){ perror( \"temp\" );exit( 1 ); }" );

    # output code to write the Awk source to the temporary file
    do
    {
        line = readLine( awkSource );
        sub( / *$/, "", line );
        if( ! atEof && line != "" )
        {
            emit( " w( \"" addEscapes( line ) "\\n\", tf );" )
        } # if ! atEof
    }
    while( ! atEof );
    close( awkSource );

    # code to close the temporary file and interpret it then delete it
    emit( " fclose( tf );" );
    emit( " system( \"" addEscapes( awkInterpreter ) \
          " " addEscapes( tempPath ) "\" );"         \
        );
    emit( " remove( \"" addEscapes( tempPath ) "\" );" );
    emit( "}" );
    close( cSource );

    if( ! ioError )
    {
        printf( "\n%s c source generated\n", cSource );
        printf( "This can now be compiled for the target system "     \
                "(possibly via cross-compilation)\n"                  \
                "using a suitable C compiler\n"                       );
    } # if ! ioError

} # BEGIN


function addEscapes( str,                                              result )
{
    result = str;
    gsub( /[\\]/, "\\\\", result );
    gsub( /"/,    "\\\"", result );

return result;
} # addEscapes


function emit( line )
{
    printf( "%s\n", line ) >> cSource;
} # emit


function readLine( fName,                                              ioStat,
                                                                       result )
{
    iostat = ( getline result < fName );
    if( iostat < 1 )
    {
        atEof  = TRUE;
        result = "";
        if( iostat < 0 )
        {
            ioError = TRUE;
            printf( "*** Error reading: %s\n", fName );
        } # if iostat < 0
    } # if iostat < 1


return result;
} # readLine
