#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

#define TRUE 1
#define FALSE 0

typedef int bool;

char grid[8][8];

void placeKings() {
    int r1, r2, c1, c2;
    for (;;) {
        r1 = rand() % 8;
        c1 = rand() % 8;
        r2 = rand() % 8;
        c2 = rand() % 8;
        if (r1 != r2 && abs(r1 - r2) > 1 && abs(c1 - c2) > 1) {
            grid[r1][c1] = 'K';
            grid[r2][c2] = 'k';
            return;
        }
    }
}

void placePieces(const char *pieces, bool isPawn) {
    int n, r, c;
    int numToPlace = rand() % strlen(pieces);
    for (n = 0; n < numToPlace; ++n) {
        do {
            r = rand() % 8;
            c = rand() % 8;
        }
        while (grid[r][c] != 0 || (isPawn && (r == 7 || r == 0)));
        grid[r][c] = pieces[n];
    }
}

void toFen() {
    char fen[80], ch;
    int r, c, countEmpty = 0, index = 0;
    for (r = 0; r < 8; ++r) {
        for (c = 0; c < 8; ++c) {
            ch = grid[r][c];
            printf("%2c ", ch == 0 ? '.' : ch);
            if (ch == 0) {
                countEmpty++;
            }
            else {
                if (countEmpty > 0) {
                    fen[index++] = countEmpty + 48;
                    countEmpty = 0;
                }
                fen[index++] = ch;
            }
        }
        if (countEmpty > 0) {
            fen[index++] = countEmpty + 48;
            countEmpty = 0;
        }
        fen[index++]= '/';
        printf("\n");
    }
    strcpy(fen + index, " w - - 0 1");
    printf("%s\n", fen);
}

char *createFen() {
    placeKings();
    placePieces("PPPPPPPP", TRUE);
    placePieces("pppppppp", TRUE);
    placePieces("RNBQBNR", FALSE);
    placePieces("rnbqbnr", FALSE);
    toFen();
}

int main() {
    srand(time(NULL));
    createFen();
    return 0;
}
