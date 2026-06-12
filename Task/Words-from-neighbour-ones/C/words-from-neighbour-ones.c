#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_WORD_SIZE 80
#define MIN_LENGTH 9
#define WORD_SIZE (MIN_LENGTH + 1)

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

int word_compare(const void* p1, const void* p2) {
    return memcmp(p1, p2, WORD_SIZE);
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
    char* words = xmalloc(WORD_SIZE * capacity);
    while (fgets(line, sizeof(line), in)) {
        size_t len = strlen(line) - 1; // last character is newline
        if (len < MIN_LENGTH)
            continue;
        line[len] = '\0';
        if (size == capacity) {
            capacity *= 2;
            words = xrealloc(words, WORD_SIZE * capacity);
        }
        memcpy(&words[size * WORD_SIZE], line, WORD_SIZE);
        ++size;
    }
    fclose(in);
    qsort(words, size, WORD_SIZE, word_compare);
    int count = 0;
    char prev_word[WORD_SIZE] = { 0 };
    for (size_t i = 0; i + MIN_LENGTH <= size; ++i) {
        char word[WORD_SIZE] = { 0 };
        for (size_t j = 0; j < MIN_LENGTH; ++j)
            word[j] = words[(i + j) * WORD_SIZE + j];
        if (word_compare(word, prev_word) == 0)
            continue;
        if (bsearch(word, words, size, WORD_SIZE, word_compare))
            printf("%2d. %s\n", ++count, word);
        memcpy(prev_word, word, WORD_SIZE);
    }
    free(words);
    return EXIT_SUCCESS;
}
