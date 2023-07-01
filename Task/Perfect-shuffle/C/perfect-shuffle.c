/* ===> INCLUDES <============================================================*/
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/* ===> CONSTANTS <===========================================================*/
#define N_DECKS 7
const int kDecks[N_DECKS] = { 8, 24, 52, 100, 1020, 1024, 10000 };

/* ===> FUNCTION PROTOTYPES <=================================================*/
int CreateDeck( int **deck, int nCards );
void InitDeck( int *deck, int nCards );
int DuplicateDeck( int **dest, const int *orig, int nCards );
int InitedDeck( int *deck, int nCards );
int ShuffleDeck( int *deck, int nCards );
void FreeDeck( int **deck );

/* ===> FUNCTION DEFINITIONS <================================================*/

int main() {
    int i, nCards, nShuffles;
    int *deck = NULL;

    for( i=0; i<N_DECKS; ++i ) {
        nCards = kDecks[i];

        if( !CreateDeck(&deck,nCards) ) {
            fprintf( stderr, "Error: malloc() failed!\n" );
            return 1;
        }

        InitDeck( deck, nCards );
        nShuffles = 0;

        do {
            ShuffleDeck( deck, nCards );
            ++nShuffles;
        } while( !InitedDeck(deck,nCards) );

        printf( "Cards count: %d, shuffles required: %d.\n", nCards, nShuffles );

        FreeDeck( &deck );
    }

    return 0;
}

int CreateDeck( int **deck, int nCards ) {
    int *tmp = NULL;

    if( deck != NULL )
        tmp = malloc( nCards*sizeof(*tmp) );

    return tmp!=NULL ? (*deck=tmp)!=NULL : 0; /* (?success) (:failure) */
}

void InitDeck( int *deck, int nCards ) {
    if( deck != NULL ) {
        int i;

        for( i=0; i<nCards; ++i )
            deck[i] = i;
    }
}

int DuplicateDeck( int **dest, const int *orig, int nCards ) {
    if( orig != NULL && CreateDeck(dest,nCards) ) {
        memcpy( *dest, orig, nCards*sizeof(*orig) );
        return 1; /* success */
    }
    else {
        return 0; /* failure */
    }
}

int InitedDeck( int *deck, int nCards ) {
    int i;

    for( i=0; i<nCards; ++i )
        if( deck[i] != i )
            return 0; /* not inited */

    return 1; /* inited */
}

int ShuffleDeck( int *deck, int nCards ) {
    int *copy = NULL;

    if( DuplicateDeck(&copy,deck,nCards) ) {
        int i, j;

        for( i=j=0; i<nCards/2; ++i, j+=2 ) {
            deck[j] = copy[i];
            deck[j+1] = copy[i+nCards/2];
        }

        FreeDeck( &copy );
        return 1; /* success */
    }
    else {
        return 0; /* failure */
    }
}

void FreeDeck( int **deck ) {
    if( *deck != NULL ) {
        free( *deck );
        *deck = NULL;
    }
}
