#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_WORD_SIZE 80

bool is_vowel(char ch) {
    switch (ch) {
    case 'a': case 'A':
    case 'e': case 'E':
    case 'i': case 'I':
    case 'o': case 'O':
    case 'u': case 'U':
        return true;
    }
    return false;
}

bool alternating_vowels_and_consonants(const char* str, size_t len) {
    for (size_t i = 1; i < len; ++i) {
        if (is_vowel(str[i]) == is_vowel(str[i - 1]))
            return false;
    }
    return true;
}

int main(int argc, char** argv) {
    const char* filename = argc < 2 ? "unixdict.txt" : argv[1];
    FILE* fp = fopen(filename, "r");
    if (!fp) {
        perror(filename);
        return EXIT_FAILURE;
    }
    char line[MAX_WORD_SIZE];
    int n = 1;
    while (fgets(line, sizeof(line), fp)) {
        size_t len = strlen(line) - 1; // last character is \n
        if (len > 9 && alternating_vowels_and_consonants(line, len))
            printf("%2d: %s", n++, line);
    }
    fclose(fp);
    return EXIT_SUCCESS;
}
