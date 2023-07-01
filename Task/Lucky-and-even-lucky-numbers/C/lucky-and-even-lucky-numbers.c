#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#define LUCKY_SIZE 60000
int luckyOdd[LUCKY_SIZE];
int luckyEven[LUCKY_SIZE];

void compactLucky(int luckyArray[]) {
    int i, j, k;

    for (i = 0; i < LUCKY_SIZE; i++) {
        if (luckyArray[i] == 0) {
            j = i;
            break;
        }
    }

    for (j = i + 1; j < LUCKY_SIZE; j++) {
        if (luckyArray[j] > 0) {
            luckyArray[i++] = luckyArray[j];
        }
    }

    for (; i < LUCKY_SIZE; i++) {
        luckyArray[i] = 0;
    }
}

void initialize() {
    int i, j;

    // unfiltered
    for (i = 0; i < LUCKY_SIZE; i++) {
        luckyEven[i] = 2 * i + 2;
        luckyOdd[i] = 2 * i + 1;
    }

    // odd filter
    for (i = 1; i < LUCKY_SIZE; i++) {
        if (luckyOdd[i] > 0) {
            for (j = luckyOdd[i] - 1; j < LUCKY_SIZE; j += luckyOdd[i]) {
                luckyOdd[j] = 0;
            }
            compactLucky(luckyOdd);
        }
    }

    // even filter
    for (i = 1; i < LUCKY_SIZE; i++) {
        if (luckyEven[i] > 0) {
            for (j = luckyEven[i] - 1; j < LUCKY_SIZE; j += luckyEven[i]) {
                luckyEven[j] = 0;
            }
            compactLucky(luckyEven);
        }
    }
}

void printBetween(size_t j, size_t k, bool even) {
    int i;

    if (even) {
        if (luckyEven[j] == 0 || luckyEven[k] == 0) {
            fprintf(stderr, "At least one argument is too large\n");
            exit(EXIT_FAILURE);
        }
        printf("Lucky even numbers between %d and %d are:", j, k);
        for (i = 0; luckyEven[i] != 0; i++) {
            if (luckyEven[i] > k) {
                break;
            }
            if (luckyEven[i] > j) {
                printf(" %d", luckyEven[i]);
            }
        }
    } else {
        if (luckyOdd[j] == 0 || luckyOdd[k] == 0) {
            fprintf(stderr, "At least one argument is too large\n");
            exit(EXIT_FAILURE);
        }
        printf("Lucky numbers between %d and %d are:", j, k);
        for (i = 0; luckyOdd[i] != 0; i++) {
            if (luckyOdd[i] > k) {
                break;
            }
            if (luckyOdd[i] > j) {
                printf(" %d", luckyOdd[i]);
            }
        }
    }
    printf("\n");
}

void printRange(size_t j, size_t k, bool even) {
    int i;

    if (even) {
        if (luckyEven[k] == 0) {
            fprintf(stderr, "The argument is too large\n");
            exit(EXIT_FAILURE);
        }
        printf("Lucky even numbers %d to %d are:", j, k);
        for (i = j - 1; i < k; i++) {
            printf(" %d", luckyEven[i]);
        }
    } else {
        if (luckyOdd[k] == 0) {
            fprintf(stderr, "The argument is too large\n");
            exit(EXIT_FAILURE);
        }
        printf("Lucky numbers %d to %d are:", j, k);
        for (i = j - 1; i < k; i++) {
            printf(" %d", luckyOdd[i]);
        }
    }
    printf("\n");
}

void printSingle(size_t j, bool even) {
    if (even) {
        if (luckyEven[j] == 0) {
            fprintf(stderr, "The argument is too large\n");
            exit(EXIT_FAILURE);
        }
        printf("Lucky even number %d=%d\n", j, luckyEven[j - 1]);
    } else {
        if (luckyOdd[j] == 0) {
            fprintf(stderr, "The argument is too large\n");
            exit(EXIT_FAILURE);
        }
        printf("Lucky number %d=%d\n", j, luckyOdd[j - 1]);
    }
}

void help() {
    printf("./lucky j [k] [--lucky|--evenLucky]\n");
    printf("\n");
    printf("       argument(s)        |  what is displayed\n");
    printf("==============================================\n");
    printf("-j=m                      |  mth lucky number\n");
    printf("-j=m  --lucky             |  mth lucky number\n");
    printf("-j=m  --evenLucky         |  mth even lucky number\n");
    printf("-j=m  -k=n                |  mth through nth (inclusive) lucky numbers\n");
    printf("-j=m  -k=n  --lucky       |  mth through nth (inclusive) lucky numbers\n");
    printf("-j=m  -k=n  --evenLucky   |  mth through nth (inclusive) even lucky numbers\n");
    printf("-j=m  -k=-n               |  all lucky numbers in the range [m, n]\n");
    printf("-j=m  -k=-n  --lucky      |  all lucky numbers in the range [m, n]\n");
    printf("-j=m  -k=-n  --evenLucky  |  all even lucky numbers in the range [m, n]\n");
}

void process(int argc, char *argv[]) {
    bool evenLucky = false;
    int j = 0;
    int k = 0;

    bool good = false;
    int i;

    for (i = 1; i < argc; ++i) {
        if ('-' == argv[i][0]) {
            if ('-' == argv[i][1]) {
                // long args
                if (0 == strcmp("--lucky", argv[i])) {
                    evenLucky = false;
                } else if (0 == strcmp("--evenLucky", argv[i])) {
                    evenLucky = true;
                } else {
                    fprintf(stderr, "Unknown long argument: [%s]\n", argv[i]);
                    exit(EXIT_FAILURE);
                }
            } else {
                // short args
                if ('j' == argv[i][1] && '=' == argv[i][2] && argv[i][3] != 0) {
                    good = true;
                    j = atoi(&argv[i][3]);
                } else if ('k' == argv[i][1] && '=' == argv[i][2]) {
                    k = atoi(&argv[i][3]);
                } else {
                    fprintf(stderr, "Unknown short argument: [%s]\n", argv[i]);
                    exit(EXIT_FAILURE);
                }
            }
        } else {
            fprintf(stderr, "Unknown argument: [%s]\n", argv[i]);
            exit(EXIT_FAILURE);
        }
    }

    if (!good) {
        help();
        exit(EXIT_FAILURE);
    }

    if (k > 0) {
        printRange(j, k, evenLucky);
    } else if (k < 0) {
        printBetween(j, -k, evenLucky);
    } else {
        printSingle(j, evenLucky);
    }
}

void test() {
    printRange(1, 20, false);
    printRange(1, 20, true);

    printBetween(6000, 6100, false);
    printBetween(6000, 6100, true);

    printSingle(10000, false);
    printSingle(10000, true);
}

int main(int argc, char *argv[]) {
    initialize();

    //test();

    if (argc < 2) {
        help();
        return 1;
    }
    process(argc, argv);

    return 0;
}
