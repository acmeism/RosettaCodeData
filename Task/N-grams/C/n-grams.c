#include <stdio.h>
#include <stdbool.h>
#include <ctype.h>
#include <string.h>

#define MAX_N 4
#define MAX_NGRAMS 20

typedef struct {
    char str[MAX_N+1];
    int freq;
} ngram;

void *strUpper(char *s) {
    while (*s) {
        *s = toupper(*s);
        s++;
    }
}

void ngrams(int n, char *text) {
    int i, j, count = 0;
    size_t len = strlen(text);
    bool found;
    char temp[MAX_N+1] = {'\0'};
    ngram ng, ngrams[MAX_NGRAMS];
    char s[len+1];
    strcpy(s, text);
    strUpper(s);
    for (i = 0; i <= len-n; ++i) {
        strncpy(temp, s + i, n);
        found = false;
        for (j = 0; j < count; ++j) {
            if (!strcmp(ngrams[j].str, temp)) {
                ngrams[j].freq++;
                found = true;
                break;
            }
        }
        if (!found) {
            strncpy(ng.str, temp, n);
            ng.freq = 1;
            ngrams[count++] = ng;
        }
    }
    for (i = 0; i < count; ++i) {
        printf("(\"%s\": %d)  ", ngrams[i].str, ngrams[i].freq);
        if (!((i+1)%5)) printf("\n");
    }
    printf("\n\n");
}

int main() {
    int n;
    char *text = "Live and let live";
    for (n = 2; n <= MAX_N; ++n) {
        printf("All %d-grams of '%s' and their frequencies:\n", n, text);
        ngrams(n, text);
    }
    return 0;
}
