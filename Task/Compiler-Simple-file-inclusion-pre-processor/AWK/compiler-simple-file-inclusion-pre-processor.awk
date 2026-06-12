# include.awk: simple file inclusion pre-processor
#
#    the command line can specify:
#        -v srcName=<source file path>

BEGIN {
    srcName  = srcName "";
} # BEGIN

{
    if( $1 == "@include" )
    {
        # must include a file
        includeFile( $0 );
    }
    else
    {
        # normal line
        printf( "%s\n", $0 );
    }
}

function includeFile( includeLine,                                   fileName,
                                                                       ioStat,
                                                                         line )
{
    # get the file name from the @include line
    fileName = includeLine;
    sub(  /^ *@include */, "", fileName );
    sub(  / *$/,           "", fileName );
    sub(  / *#.*$/,        "", fileName );
    if( fileName ~ /^"/ )
    {
        # quoted file name
        sub(  /^"/,        "", fileName );
        sub(  /"$/,        "", fileName );
        gsub( /""/,      "\"", fileName );
    }
    printf( "#line 1 %s\n",    fileName );
    while( ( ioStat = ( getline line < fileName ) ) > 0 )
    {
        # have a source line
        printf( "%s\n", line );
    }
    if( ioStat < 0 )
    {
        # I/O error
        printf( "@include %s # not found or I/O error\n", fileName );
    }
    close( fileName );
    printf( "#line %d %s\n", NR, ( srcName != "" ? srcName : FILENAME ) );

} # includeFile
