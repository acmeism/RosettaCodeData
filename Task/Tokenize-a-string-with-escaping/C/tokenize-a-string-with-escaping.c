#include <stdlib.h>
#include <stdio.h>

#define STR_DEMO "one^|uno||three^^^^|four^^^|^cuatro|"
#define SEP '|'
#define ESC '^'

typedef char* Str; /* just for an easier reading */

/* ===> FUNCTION PROTOTYPES <================================================ */
unsigned int ElQ( const char *s, char sep, char esc );
Str *Tokenize( char *s, char sep, char esc, unsigned int *q );

/*==============================================================================
Main function.
Just passes a copy of the STR_DEMO string to the tokenization function and shows
the results.
==============================================================================*/

int main() {
    char s[] = STR_DEMO;
    unsigned int i, q;

    Str *list = Tokenize( s, SEP, ESC, &q );

    if( list != NULL ) {
        printf( "\n Original string: %s\n\n", STR_DEMO );
        printf( " %d tokens:\n\n", q );

        for( i=0; i<q; ++i )
            printf( " %4d. %s\n", i+1, list[i] );

        free( list );
    }

    return 0;
}

/*==============================================================================
"ElQ" stands for "Elements Quantity". Counts the amount of valid element in the
string s, according to the separator character provided in sep and the escape
character provided in esc.
==============================================================================*/

unsigned int ElQ( const char *s, char sep, char esc ) {
    unsigned int q, e;
    const char *p;

    for( e=0, q=1, p=s; *p; ++p ) {
        if( *p == esc )
            e = !e;
        else if( *p == sep )
            q += !e;
        else e = 0;
    }

    return q;
}

/*==============================================================================
The actual tokenization function.
Allocates as much dynamic memory as needed to contain the pointers to the
tokenized portions of the string passed as the "s" parameter, then looks for the
separators characters sep, paying attention to the occurrences of the escape
character provided in esc. When a valid separator is found, the function swaps
it with a '\0' terminator character and stores the pointer to the next string
into the array of pointers in dynamic memory. On output, the value of *q is the
number of pointers in the array. The caller is responsible for deallocating with
free() the returned array of pointers when it is no longer needed.
In case of failure, NULL is returned.
==============================================================================*/

Str *Tokenize( char *s, char sep, char esc, unsigned int *q ) {
    Str *list = NULL;

    *q = ElQ( s, sep, esc );
    list = malloc( *q * sizeof(Str) );

    if( list != NULL ) {
        unsigned int e, i;
        char *p;

        i = 0;
        list[i++] = s;

        for( e=0, p=s; *p; ++p ) {
            if( *p == esc ) {
                e = !e;
            }
            else if( *p == sep && !e ) {
                list[i++] = p+1;
                *p = '\0';
            }
            else {
                e = 0;
            }
        }
    }

    return list;
}
