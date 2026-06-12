#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_WORD_SIZE 128
#define MIN_WORD_LENGTH 6

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

int string_compare(const void* p1, const void* p2) {
    const char* const* s1 = p1;
    const char* const* s2 = p2;
    return strcmp(*s1, *s2);
}

char* string_copy(const char* str) {
    size_t len = strlen(str);
    char* str2 = xmalloc(len + 1);
    memcpy(str2, str, len + 1);
    return str2;
}

char** load_dictionary(const char* filename, size_t* psize) {
    FILE* in = fopen(filename, "r");
    if (!in) {
        perror(filename);
        return NULL;
    }
    size_t size = 0, capacity = 1024;
    char** dictionary = xmalloc(sizeof(char*) * capacity);
    char line[MAX_WORD_SIZE];
    while (fgets(line, sizeof(line), in)) {
        size_t len = strlen(line);
        if (len > MIN_WORD_LENGTH) {
            line[len - 1] = '\0'; // discard newline
            char* str = string_copy(line);
            if (size == capacity) {
                capacity <<= 1;
                dictionary = xrealloc(dictionary, sizeof(char*) * capacity);
            }
            dictionary[size++] = str;
        }
    }
    fclose(in);
    qsort(dictionary, size, sizeof(char*), string_compare);
    *psize = size;
    return dictionary;
}

void free_dictionary(char** dictionary, size_t size) {
    for (size_t i = 0; i < size; ++i)
        free(dictionary[i]);
    free(dictionary);
}

bool find_word(char** dictionary, size_t size, const char* word) {
    return bsearch(&word, dictionary, size, sizeof(char*), string_compare) !=
           NULL;
}

int main(int argc, char** argv) {
    const char* filename = argc < 2 ? "unixdict.txt" : argv[1];
    size_t size = 0;
    char** dictionary = load_dictionary(filename, &size);
    if (dictionary == NULL)
        return EXIT_FAILURE;
    int count = 0;
    for (size_t i = 0; i < size; ++i) {
        const char* word1 = dictionary[i];
        if (strchr(word1, 'e') != NULL) {
            char* word2 = string_copy(word1);
            for (char* p = word2; *p; ++p) {
                if (*p == 'e')
                    *p = 'i';
            }
            if (find_word(dictionary, size, word2))
                printf("%2d. %-10s -> %s\n", ++count, word1, word2);
            free(word2);
        }
    }
    free_dictionary(dictionary, size);
    return EXIT_SUCCESS;
}
