#include <string.h>
#include <stdio.h>
#include <stdlib.h>

const char STX = '\002', ETX = '\003';

int compareStrings(const void *a, const void *b) {
    char *aa = *(char **)a;
    char *bb = *(char **)b;
    return strcmp(aa, bb);
}

int bwt(const char *s, char r[]) {
    int i, len = strlen(s) + 2;
    char *ss, *str;
    char **table;
    if (strchr(s, STX) || strchr(s, ETX)) return 1;
    ss = calloc(len + 1, sizeof(char));
    sprintf(ss, "%c%s%c", STX, s, ETX);
    table = malloc(len * sizeof(const char *));
    for (i = 0; i < len; ++i) {
        str = calloc(len + 1, sizeof(char));
        strcpy(str, ss + i);
        if (i > 0) strncat(str, ss, i);
        table[i] = str;
    }
    qsort(table, len, sizeof(const char *), compareStrings);
    for(i = 0; i < len; ++i) {
        r[i] = table[i][len - 1];
        free(table[i]);
    }
    free(table);
    free(ss);
    return 0;
}

void ibwt(const char *r, char s[]) {
    int i, j, len = strlen(r);
    char **table = malloc(len * sizeof(const char *));
    for (i = 0; i < len; ++i) table[i] = calloc(len + 1, sizeof(char));
    for (i = 0; i < len; ++i) {
        for (j = 0; j < len; ++j) {
            memmove(table[j] + 1, table[j], len);
            table[j][0] = r[j];
        }
        qsort(table, len, sizeof(const char *), compareStrings);
    }
    for (i = 0; i < len; ++i) {
        if (table[i][len - 1] == ETX) {
            strncpy(s, table[i] + 1, len - 2);
            break;
        }
    }
    for (i = 0; i < len; ++i) free(table[i]);
    free(table);
}

void makePrintable(const char *s, char t[]) {
    strcpy(t, s);
    for ( ; *t != '\0'; ++t) {
        if (*t == STX) *t = '^';
        else if (*t == ETX) *t = '|';
    }
}

int main() {
    int i, res, len;
    char *tests[6], *t, *r, *s;
    tests[0] = "banana";
    tests[1] = "appellee";
    tests[2] = "dogwood";
    tests[3] = "TO BE OR NOT TO BE OR WANT TO BE OR NOT?";
    tests[4] = "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES",
    tests[5] = "\002ABC\003";
    for (i = 0; i < 6; ++i) {
        len = strlen(tests[i]);
        t = calloc(len + 1, sizeof(char));
        makePrintable(tests[i], t);
        printf("%s\n", t);
        printf(" --> ");
        r = calloc(len + 3, sizeof(char));
        res = bwt(tests[i], r);
        if (res == 1) {
            printf("ERROR: String can't contain STX or ETX\n");
        }
        else {
            makePrintable(r, t);
            printf("%s\n", t);
        }
        s = calloc(len + 1, sizeof(char));
        ibwt(r, s);
        makePrintable(s, t);
        printf(" --> %s\n\n", t);
        free(t);
        free(r);
        free(s);
    }
    return 0;
}
