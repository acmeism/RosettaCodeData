#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAXLINES    1000000
#define MAXLEN      1000

char buffer[MAXLEN];
char* words[MAXLINES];
char* wordsReversed[MAXLINES];

void reverseString(char* s) {
    int c, i, j;
    for (i = 0, j = strlen(s) - 1; i < j; i++, j--) {
        c = s[i];
        s[i] = s[j];
        s[j] = c;
    }
}

int pstrcmp(const void* a, const void* b) {
    return strcmp(*(const char**)a, *(const char**)b);
}

int main() {
    int i, j;
    int wordCount;

    FILE* file = fopen("words.txt", "r");

    wordCount = 0;
    while (fgets(buffer, MAXLEN, file)) {
        buffer[strcspn(buffer, "\n")] = 0;
        if (strlen(buffer) > 6) {
            words[wordCount] = malloc(strlen(buffer) + 1);
            strcpy(words[wordCount], buffer);
            wordCount++;
        }
    }

    fclose(file);

    for (i = 0; i < wordCount; i++) {
        wordsReversed[i] = malloc(strlen(words[i]) + 1);
        strcpy(wordsReversed[i], words[i]);
        reverseString(wordsReversed[i]);
    }

    qsort(wordsReversed, wordCount, sizeof(char*), pstrcmp);

    for (i = 0; i < wordCount; i++) {
        strcpy(buffer, words[i]);
        reverseString(buffer);
        if (strcmp(words[i], buffer) < 0 &&
            bsearch(&words[i], wordsReversed, wordCount, sizeof(char*), pstrcmp))
            printf("%-12s%-12s\n", words[i], buffer);
    }

    for (i = 0; i < wordCount; i++) {
        free(words[i]);
        free(wordsReversed[i]);
    }

    return 0;
}
