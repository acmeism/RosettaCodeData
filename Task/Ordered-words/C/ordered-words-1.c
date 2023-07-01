#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <assert.h>


#define MAXLEN 100
typedef char TWord[MAXLEN];


typedef struct Node {
    TWord word;
    struct Node *next;
} Node;


int is_ordered_word(const TWord word) {
    assert(word != NULL);
    int i;

    for (i = 0; word[i] != '\0'; i++)
        if (word[i] > word[i + 1] && word[i + 1] != '\0')
            return 0;

    return 1;
}


Node* list_prepend(Node* words_list, const TWord new_word) {
    assert(new_word != NULL);
    Node *new_node = malloc(sizeof(Node));
    if (new_node == NULL)
        exit(EXIT_FAILURE);

    strcpy(new_node->word, new_word);
    new_node->next = words_list;
    return new_node;
}


Node* list_destroy(Node *words_list) {
    while (words_list != NULL) {
        Node *temp = words_list;
        words_list = words_list->next;
        free(temp);
    }

    return words_list;
}


void list_print(Node *words_list) {
    while (words_list != NULL) {
        printf("\n%s", words_list->word);
        words_list = words_list->next;
    }
}


int main() {
    FILE *fp = fopen("unixdict.txt", "r");
    if (fp == NULL)
        return EXIT_FAILURE;

    Node *words = NULL;
    TWord line;
    unsigned int max_len = 0;

    while (fscanf(fp, "%99s\n", line) != EOF) {
        if (strlen(line) > max_len && is_ordered_word(line)) {
            max_len = strlen(line);
            words = list_destroy(words);
            words = list_prepend(words, line);
        } else if (strlen(line) == max_len && is_ordered_word(line)) {
            words = list_prepend(words, line);
        }
    }

    fclose(fp);
    list_print(words);

    return EXIT_SUCCESS;
}
