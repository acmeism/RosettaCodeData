#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <assert.h>


#define MAXLEN 100
typedef char TWord[MAXLEN];


typedef struct WordsArray {
    TWord *words;
    size_t len;
} WordsArray;


int is_ordered_word(const TWord word) {
    assert(word != NULL);
    int i;

    for (i = 0; word[i] != '\0'; i++)
        if (word[i] > word[i + 1] && word[i + 1] != '\0')
            return 0;

    return 1;
}


void array_append(WordsArray *words_array, const TWord new_word) {
    assert(words_array != NULL);
    assert(new_word != NULL);
    assert((words_array->len == 0) == (words_array->words == NULL));

    words_array->len++;
    words_array->words = realloc(words_array->words,
                                 words_array->len * sizeof(words_array->words[0]));
    if (words_array->words == NULL)
        exit(EXIT_FAILURE);
    strcpy(words_array->words[words_array->len-1], new_word);
}


void array_free(WordsArray *words_array) {
    assert(words_array != NULL);
    free(words_array->words);
    words_array->words = NULL;
    words_array->len = 0;
}


void list_print(WordsArray *words_array) {
    assert(words_array != NULL);
    size_t i;
    for (i = 0; i < words_array->len; i++)
        printf("\n%s", words_array->words[i]);
}


int main() {
    FILE *fp = fopen("unixdict.txt", "r");
    if (fp == NULL)
        return EXIT_FAILURE;

    WordsArray words;
    words.len = 0;
    words.words = NULL;

    TWord line;
    line[0] = '\0';
    unsigned int max_len = 0;

    while (fscanf(fp, "%99s\n", line) != EOF) { // 99 = MAXLEN - 1
        if (strlen(line) > max_len && is_ordered_word(line)) {
            max_len = strlen(line);
            array_free(&words);
            array_append(&words, line);
        } else if (strlen(line) == max_len && is_ordered_word(line)) {
            array_append(&words, line);
        }
    }

    fclose(fp);
    list_print(&words);
    array_free(&words);

    return EXIT_SUCCESS;
}
