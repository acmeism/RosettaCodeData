#include <stdio.h>
#include <stdlib.h>
#include <string.h>


/* "Use the dictionary unixdict.txt" */
#define DICTIONARY_FILE_NAME "unixdict.txt"

/* "The length of any word shown should be >10" */
#define MIN_WORD_LENGTH 11


char *create_word_buffer( const char *file_name, size_t *buffer_size );
int verify_vowels( const char *word, size_t word_length );
int wait_for_return( void );


int main() {
    size_t buffer_size = 0;
    char *buffer = create_word_buffer( DICTIONARY_FILE_NAME, &buffer_size );

    if( buffer ) {
        FILE *f = fopen( DICTIONARY_FILE_NAME, "r" );

        if( f ) {
            while( fgets(buffer,buffer_size,f) ) {
                size_t l = strlen( buffer );
                if( '\n'==buffer[l-1] ) buffer[--l] = '\0';

                if( l>=MIN_WORD_LENGTH && verify_vowels(buffer,l) ) {
                    printf( "%s\n", buffer );
                }
            }

            fclose( f ); f = NULL; /* cleanup */
        } else puts( "Couldn't open dictionary file." );

        free( buffer ); buffer = NULL; /* cleanup */
    } else puts( "Couldn't create word buffer." );

    return wait_for_return();
}


/*==============================================================================
No need to verify any parameters in any of the following function - the caller
did his homeworks.
==============================================================================*/


size_t get_line_length( FILE *f ) {
    size_t line_length = 0;
    int c, ok;

    do {
        c = fgetc(f);
        ok = '\n'!=c&&EOF!=c;
        line_length += ok;
    } while( ok );

    return line_length;
}


size_t find_longest_line_in_file( const char *file_name ) {
    size_t max_line_length = ((size_t)-1);

    FILE *f = fopen( file_name, "r" );

    if( f ) {
        max_line_length = 0;

        while( !feof(f) ) {
            size_t line_length = get_line_length( f );

            if( line_length>max_line_length )
                max_line_length = line_length;
        }

        fclose( f ); f = NULL;
    }

    return max_line_length;
}


char *create_word_buffer( const char *file_name, size_t *buffer_size ) {
    char *buffer = NULL;

    size_t max_line_length = find_longest_line_in_file( file_name );

    if( ((size_t)-1)!=max_line_length ) {
        buffer = calloc( max_line_length+2, sizeof(*buffer) );
        if( buffer ) *buffer_size = max_line_length+2;
    }

    return buffer;
}


int verify_vowels( const char *word, size_t word_length ) {
    int vowel_instances[5] = {0};
    size_t i;

    for( i=0; i<word_length; ++i ) {
        switch( word[i] ) {
            case 'A': case 'a': vowel_instances[0]++; break;
            case 'E': case 'e': vowel_instances[1]++; break;
            case 'I': case 'i': vowel_instances[2]++; break;
            case 'O': case 'o': vowel_instances[3]++; break;
            case 'U': case 'u': vowel_instances[4]++; break;
            default: ;
        }
    }

    return 1==vowel_instances[0] &&
           1==vowel_instances[1] &&
           1==vowel_instances[2] &&
           1==vowel_instances[3] &&
           1==vowel_instances[4];
}


int wait_for_return( void ) {
    puts( "\nPress Return to exit...    " );
    while( '\n'!=getchar() );
    return 0;
}
