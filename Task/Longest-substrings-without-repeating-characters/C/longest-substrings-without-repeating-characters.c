#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

struct substr {
    const char *start;
    size_t length;
};

struct substr *lswrc(const char *str) {
    size_t length = strlen(str);
    struct substr *arr = malloc(sizeof(struct substr) * (length + 1));
    if (!arr) return NULL;

    size_t start=0, i=0, maxStart=0, maxEnd=0, n=0;
    bool used[256] = {false};

    for (i=0; i<length; i++) {
        while (used[(unsigned char) str[i]])
            used[(unsigned char) str[start++]] = false;
        used[(unsigned char) str[i]] = true;
        if (i-start >= maxEnd-maxStart) {
            maxStart = start;
            maxEnd = i;
            size_t len = maxEnd - maxStart + 1;
            while (n>0 && arr[n-1].length < len) n--;
            arr[n].start = &str[start];
            arr[n].length = len;
            n++;
        }
    }

    arr[n].start = NULL;
    arr[n].length = 0;
    return realloc(arr, sizeof(struct substr) * (n+1));
}

int main() {
    char *examples[] = {"xyzyabcybdfd", "xyzyab", "zzzzz", "a", "", NULL};

    for (size_t i=0; examples[i]; i++) {
        printf("Original string: \"%s\"\n", examples[i]);
        printf("Longest substrings: ");
        struct substr *ls = lswrc(examples[i]);
        for (size_t j=0; ls[j].start; j++)
            printf("\"%.*s\" ", (int)ls[j].length, ls[j].start);
        printf("\n");
        free(ls);
    }

    return 0;
}
