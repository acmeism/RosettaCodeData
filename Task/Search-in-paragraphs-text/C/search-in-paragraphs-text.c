#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define INPUT_FILE_NAME     "Traceback.txt"
#define KEYWORD_STRING      "SystemError"
#define TRACEBACK_STRING    "Traceback (most recent call last):"
#define END_OF_PARAGRAPH    "\n----------------\n"

char *load_paragraph( FILE *f );

int main() {
    FILE *f   = fopen( INPUT_FILE_NAME, "r" );

    if( f ) {
        char *par = NULL;

        while( (par=load_paragraph(f)) ) {
            if( strstr(par,KEYWORD_STRING) ) {
                char *p = strstr( par, TRACEBACK_STRING );

                if( p ) printf( p );
                else printf( "%s\n%s", TRACEBACK_STRING, par );

                printf( END_OF_PARAGRAPH );
            }

            free( par ); par = NULL;
        }

        if( !feof(f) )
            puts( "End of file not reached." );

        fclose( f ); f = NULL;
    }
    else {
        puts( "Input file not opened." );
    }

    return 0;
}

/*===========================================================================
Starting from the current position, looks for the first occurrence of "\n\n"
in the file f, counting the number of characters from the current position
to "\n\n" itself (not included) or to the end of the file (whichever occurs
first). Resets the file to its original position, then returns the number of
characters.
If the funtions fails, it returns ((size_t)-1).
===========================================================================*/

size_t get_paragraph_length( FILE *f ) {
    size_t l = ((size_t)-1);

    if( f && !feof(f) ) {
        fpos_t ex_pos;

        if( 0==fgetpos(f,&ex_pos) ) {
            int c;

            for( c=fgetc(f); c!=EOF; c=fgetc(f) ) {
                if( '\n'==c ) {
                    if( '\n'!=(c=fgetc(f)) ) {
                        ungetc( c, f );
                    }
                    else {
                        ++l;
                        break;
                    }
                }

                ++l;
            }

            l += EOF==c;

            fsetpos( f, &ex_pos );
        }
    }

    return l;
}

/*===========================================================================
Loads a paragraph from the file f. Paragraphs are detected looking for the
occurrences of "\n\n" separators. The loaded paragraph is put into a chunk of
memory allocated with malloc(). The pointer to that memory is returned.
If the function fails, no memory is allocated and NULL is returned.
===========================================================================*/

char *load_paragraph( FILE *f ) {
    char *par = NULL;

    if( !feof(f) ) {
        size_t i, l = get_paragraph_length( f );

        if( ((size_t)-1)!=l ) {
            par = malloc( l+1 );

            if( par ) {
                for( i=0; i<l; ++i )
                    par[i] = fgetc( f );
                par[i] = '\0';

                /* just jump beyond the paragraph delimiter */
                fgetc( f ); fgetc( f );
            }
        }
    }

    return par;
}
