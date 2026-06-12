#include <stdio.h>
#include <errno.h>
static void w( char * line, FILE * tf )
{fputs( line, tf );
 if( errno != 0 ){ perror( "temp" );exit( 2 ); }
}
int main( int argc, char ** argv )
{FILE * tf = fopen( "/tmp/t", "w" );
 if( tf == NULL ){ perror( "temp" );exit( 1 ); }
 w( "BEGIN \\\n", tf );
 w( "{\n", tf );
 w( "    printf( \"Hello, World!\\n\" );\n", tf );
 w( "} # BEGIN\n", tf );
 fclose( tf );
 system( "awk -f /tmp/t" );
 remove( "/tmp/t" );
}
