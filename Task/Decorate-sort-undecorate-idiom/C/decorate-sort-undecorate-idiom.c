#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    const char *word;
    size_t key;
} wordkey;

int compare(const void* p1, const void* p2) {
    const int ip1 = ((wordkey *)p1)->key;
    const int ip2 = ((wordkey *)p2)->key;
    return (ip1 < ip2) ? -1 : ((ip1 > ip2) ? 1 : 0);
}

size_t length(const char *s) { return strlen(s); }

void sortWords(char **words, size_t le, size_t (*f)(const char* s)) {
    int i;
    char words2[le][15]; // to store the sorted array

    /* decorate */
    wordkey wordkeys[le];
    for (i = 0; i < le; ++i) {
        wordkeys[i] = (wordkey){words[i], f(words[i])};
    }

    /* sort (unstable) */
    qsort(wordkeys, le, sizeof(wordkey), compare);

    /* undecorate and print */
    printf("[");
    for (i = 0; i < le; ++i) {
        sprintf(words2[i], "\"%s\"", wordkeys[i].word);
        printf("%s, ", words2[i]);
    }
    printf("\b\b]\n");
}

int main() {
    char *words[7] = {'\0'};
    words[0] = "Rosetta";
    words[1] = "Code";
    words[2] = "is";
    words[3] = "a";
    words[4] = "programming";
    words[5] = "chrestomathy";
    words[6] = "site";
    sortWords(words, 7, length);
    return 0;
}
