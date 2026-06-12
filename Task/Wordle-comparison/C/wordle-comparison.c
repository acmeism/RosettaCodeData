#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void wordle(const char *answer, const char *guess, int *result) {
    int i, ix, n = strlen(guess);
    char *ptr;
    if (n != strlen(answer)) {
        printf("The words must be of the same length.\n");
        exit(1);
    }
    char answer2[n+1];
    strcpy(answer2, answer);
    for (i = 0; i < n; ++i) {
        if (guess[i] == answer2[i]) {
            answer2[i] = '\v';
            result[i] = 2;
        }
    }
    for (i = 0; i < n; ++i) {
        if ((ptr = strchr(answer2, guess[i])) != NULL) {
            ix = ptr - answer2;
            answer2[ix] = '\v';
            result[i] = 1;
        }
    }
}

int main() {
    int i, j;
    const char *answer, *guess;
    int res[5];
    const char *res2[5];
    const char *colors[3] = {"grey", "yellow", "green"};
    const char *pairs[5][2] = {
        {"ALLOW", "LOLLY"},
        {"BULLY", "LOLLY"},
        {"ROBIN", "ALERT"},
        {"ROBIN", "SONIC"},
        {"ROBIN", "ROBIN"}
    };
    for (i = 0; i < 5; ++i) {
        answer = pairs[i][0];
        guess  = pairs[i][1];
        for (j = 0; j < 5; ++j) res[j] = 0;
        wordle(answer, guess, res);
        for (j = 0; j < 5; ++j) res2[j] = colors[res[j]];
        printf("%s v %s => { ", answer, guess);
        for (j = 0; j < 5; ++j) printf("%d ", res[j]);
        printf("} => { ");
        for (j = 0; j < 5; ++j) printf("%s ", res2[j]);
        printf("}\n");
    }
    return 0;
}
