#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

// low <= num < high
int randInt(int low, int high) {
    return (rand() % (high - low)) + low;
}

// shuffle an array of n elements
void shuffle(int *const array, const int n) {
    if (n > 1) {
        int i;
        for (i = 0; i < n - 1; i++) {
            int j = randInt(i, n);

            int t = array[i];
            array[i] = array[j];
            array[j] = t;
        }
    }
}

// print an n * n array
void printSquare(const int *const latin, const int n) {
    int i, j;
    for (i = 0; i < n; i++) {
        printf("[");
        for (j = 0; j < n; j++) {
            if (j > 0) {
                printf(", ");
            }
            printf("%d", latin[i * n + j]);
        }
        printf("]\n");
    }
    printf("\n");
}

void latinSquare(const int n) {
    int *latin, *used;
    int i, j, k;

    if (n <= 0) {
        printf("[]\n");
        return;
    }

    // allocate
    latin = (int *)malloc(n * n * sizeof(int));
    if (!latin) {
        printf("Failed to allocate memory.");
        return;
    }

    // initialize
    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            latin[i * n + j] = j;
        }
    }

    // first row
    shuffle(latin, n);

    // middle row(s)
    for (i = 1; i < n - 1; i++) {
        bool shuffled = false;

        while (!shuffled) {
            shuffle(&latin[i * n], n);

            for (k = 0; k < i; k++) {
                for (j = 0; j < n; j++) {
                    if (latin[k * n + j] == latin[i * n + j]) {
                        goto shuffling;
                    }
                }
            }
            shuffled = true;

        shuffling: {}
        }
    }

    //last row
    used = (int *)malloc(n * sizeof(int));
    for (j = 0; j < n; j++) {
        memset(used, 0, n * sizeof(int));
        for (i = 0; i < n - 1; i++) {
            used[latin[i * n + j]] = 1;
        }
        for (k = 0; k < n; k++) {
            if (used[k] == 0) {
                latin[(n - 1) * n + j] = k;
                break;
            }
        }
    }
    free(used);

    // print the result
    printSquare(latin, n);
    free(latin);
}

int main() {
    // initialze the random number generator
    srand((unsigned int)time((time_t)0));

    latinSquare(5);
    latinSquare(5);
    latinSquare(10);

    return 0;
}
