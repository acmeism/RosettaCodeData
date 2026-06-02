#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>

#define MAX_LINES 100000
#define MAX_LEN 256

char *words[MAX_LINES], *isograms[MAX_LINES];
char buffer[MAX_LEN];

int countChar(const char* s, char c) {
    int res = 0;
    for ( ; *s; s++)
        if (*s == c)
            res++;
    return res;
}

bool isIsogram(const char* s) {
    int firstCount;
    const char* p;

    firstCount = countChar(s, s[0]);
    for (p = s; *p; p++)
        if (countChar(s, *p) != firstCount)
            return false;
    return true;
}

int isogramLevel(const char* s) {
    return countChar(s, s[0]);
}

int compare(const void* a, const void* b)
{
    const char* str_a = *(const char**)a;
    const char* str_b = *(const char**)b;
    if (isogramLevel(str_a) < isogramLevel(str_b)) return 1;
    if (isogramLevel(str_a) > isogramLevel(str_b)) return -1;
    if (strlen(str_a) < strlen(str_b)) return 1;
    if (strlen(str_a) > strlen(str_b)) return -1;
    return strcmp(str_a, str_b);
}

int main() {
    int wordCount, isogramCount, i;
    char* target;
    FILE *fp = fopen("unixdict.txt", "r");

    while (fgets(buffer, sizeof(buffer), fp)) {
        buffer[strcspn(buffer, "\n")] = '\0';
        words[wordCount] = malloc(strlen(buffer) + 1);
        strcpy(words[wordCount], buffer);
        wordCount++;
    }

    fclose(fp);

    isogramCount = 0;
    for (i = 0; i < wordCount; i++)
        if (isIsogram(words[i]) && isogramLevel(words[i]) > 1)
            isograms[isogramCount++] = words[i];

    qsort(isograms, isogramCount, sizeof(char*), compare);

    printf("n-isograms with n > 1:\n");
    for (i = 0; i < isogramCount; i++)
        printf("%s\n", isograms[i]);

    isogramCount = 0;
    for (i = 0; i < wordCount; i++)
        if (isIsogram(words[i]) && isogramLevel(words[i]) == 1 && strlen(words[i]) > 10)
            isograms[isogramCount++] = words[i];

    qsort(isograms, isogramCount, sizeof(char*), compare);

    printf("\n");
    printf("Heterograms with more than 10 letters:");
    for (i = 0; i < isogramCount; i++)
        printf("%s\n", isograms[i]);

    for (i = 0; i < wordCount; i++)
        free(words[i]);
}
