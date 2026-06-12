#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_WORD_SIZE 32

typedef struct string_tag {
    size_t length;
    char str[MAX_WORD_SIZE];
} string_t;

void fatal(const char* message) {
    fprintf(stderr, "%s\n", message);
    exit(1);
}

void* xmalloc(size_t n) {
    void* ptr = malloc(n);
    if (ptr == NULL)
        fatal("Out of memory");
    return ptr;
}

void* xrealloc(void* p, size_t n) {
    void* ptr = realloc(p, n);
    if (ptr == NULL)
        fatal("Out of memory");
    return ptr;
}

int hamming_distance(const string_t* str1, const string_t* str2) {
    size_t len1 = str1->length;
    size_t len2 = str2->length;
    if (len1 != len2)
        return 0;
    int count = 0;
    const char* s1 = str1->str;
    const char* s2 = str2->str;
    for (size_t i = 0; i < len1; ++i) {
        if (s1[i] != s2[i])
            ++count;
        // don't care about counts > 2 in this case
        if (count == 2)
            break;
    }
    return count;
}

int main(int argc, char** argv) {
    const char* filename = argc < 2 ? "unixdict.txt" : argv[1];
    FILE* in = fopen(filename, "r");
    if (!in) {
        perror(filename);
        return EXIT_FAILURE;
    }
    char line[MAX_WORD_SIZE];
    size_t size = 0, capacity = 1024;
    string_t* dictionary = xmalloc(sizeof(string_t) * capacity);
    while (fgets(line, sizeof(line), in)) {
        if (size == capacity) {
            capacity *= 2;
            dictionary = xrealloc(dictionary, sizeof(string_t) * capacity);
        }
        size_t len = strlen(line) - 1;
        if (len > 11) {
            string_t* str = &dictionary[size];
            str->length = len;
            memcpy(str->str, line, len);
            str->str[len] = '\0';
            ++size;
        }
    }
    fclose(in);
    printf("Changeable words in %s:\n", filename);
    int n = 1;
    for (size_t i = 0; i < size; ++i) {
        const string_t* str1 = &dictionary[i];
        for (size_t j = 0; j < size; ++j) {
            const string_t* str2 = &dictionary[j];
            if (i != j && hamming_distance(str1, str2) == 1)
                printf("%2d: %-14s -> %s\n", n++, str1->str, str2->str);
        }
    }
    free(dictionary);
    return EXIT_SUCCESS;
}
