#include <stdio.h>
#include <errno.h>
static void w( char * line, FILE * tf )
{fputs( line, tf );
 if( errno != 0 ){ perror( "temp" );exit( 2 ); }
}
int main( int argc, char ** argv )
{FILE * tf = fopen( "/tmp/t", "w" );
 if( tf == NULL ){ perror( "temp" );exit( 1 ); }
 w( "print( ( \"Hello, World!\", newline ) )\n", tf );
 fclose( tf );
 system( "a68g /tmp/t" );
 remove( "/tmp/t" );
}
