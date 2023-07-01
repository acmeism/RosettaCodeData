#include <stdbool.h>
#include <stdio.h>

#define MAX_WORD 80
#define LETTERS 26

bool is_letter(char c) { return c >= 'a' && c <= 'z'; }

int index(char c) { return c - 'a'; }

void word_wheel(const char* letters, char central, int min_length, FILE* dict) {
    int max_count[LETTERS] = { 0 };
    for (const char* p = letters; *p; ++p) {
        char c = *p;
        if (is_letter(c))
            ++max_count[index(c)];
    }
    char word[MAX_WORD + 1] = { 0 };
    while (fgets(word, MAX_WORD, dict)) {
        int count[LETTERS] = { 0 };
        for (const char* p = word; *p; ++p) {
            char c = *p;
            if (c == '\n') {
                if (p >= word + min_length && count[index(central)] > 0)
                    printf("%s", word);
            } else if (is_letter(c)) {
                int i = index(c);
                if (++count[i] > max_count[i]) {
                    break;
                }
            } else {
                break;
            }
        }
    }
}

int main(int argc, char** argv) {
    const char* dict = argc == 2 ? argv[1] : "unixdict.txt";
    FILE* in = fopen(dict, "r");
    if (in == NULL) {
        perror(dict);
        return 1;
    }
    word_wheel("ndeokgelw", 'k', 3, in);
    fclose(in);
    return 0;
}
