#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>

#define WORD_BUF_SIZE 30
#define MIN_WORD_SIZE 6

/* Print last error and exit */
void fail(void) {
    fprintf(stderr, "%s\n", strerror(errno));
    exit(42);
}

/* Define a trie data structure to store the words */
struct trie_node {
    char ch, final;
    struct trie_node *parent, *sibling, *root, *child;
};

struct trie_node *alloc_node() {
    struct trie_node *t = calloc(1, sizeof(struct trie_node));
    if (t == NULL) fail();
    return t;
}

struct trie_node *make_sibling(struct trie_node *node) {
    struct trie_node *t = alloc_node();
    node->sibling = t;
    t->ch = node->ch;
    t->parent = node->parent;
    t->root = node->root;
    return t;
}

struct trie_node *make_child(struct trie_node *node, char ch) {
    struct trie_node *t = alloc_node();
    t->parent = node;
    t->ch = ch;
    t->root = node->root;
    node->child = t;
    return t;
}

/* Add a word to the trie */
struct trie_node *add_word(struct trie_node *root, const char *word) {
    struct trie_node *cur = root;
    for (; *word; word++) {
        while (cur->child == NULL || cur->child->ch != *word) {
            if (cur->child == NULL) {
                /* Node does not exist yet; insert it */
                make_child(cur, *word);
            } else {
                /* Check next sibling, if it exists */
                if (cur->sibling == NULL) make_sibling(cur);
                cur = cur->sibling;
            }
        }

        /* We have either made or found the right node, descend */
        cur = cur->child;
    }
    cur->final = 1; /* This node marks the end of a word */
    return cur;
}

/* Check if a word is in the trie; returns the word or NULL if not there */
struct trie_node *find_word(struct trie_node *root, const char *word) {
    struct trie_node *cur = root;
    for (; *word && cur; word++) {
        while (cur != NULL && cur->child != NULL && cur->child->ch != *word) {
            cur = cur->sibling;
        }
        if (cur == NULL) return NULL; /* node doesn't exist */
        cur = cur->child;
    }
    if (cur && cur->final) return cur;
    else return NULL;
}

/* Call function for every word in the trie */
void scan_trie(struct trie_node *node, void callback(struct trie_node *)) {
    if (node == NULL) return;
    if (node->final) callback(node);
    scan_trie(node->child, callback);
    scan_trie(node->sibling, callback);
}

/* Retrieve word from trie given pointer to end node */
char *get_word(struct trie_node *node, char *buffer) {
    char t, *ch = buffer, *s = buffer;
    for (; node != NULL; node=node->parent) *ch++ = node->ch;
    for (ch-=2; ch >= s; ch--, s++) *ch ^= *s ^= *ch ^= *s;
    return buffer;
}

/* See if a word is an alternade, and print it if it is */
void check_alternade(struct trie_node *node) {
    static char word[WORD_BUF_SIZE], even[WORD_BUF_SIZE], odd[WORD_BUF_SIZE];
    char *p_even = even, *p_odd = odd;
    int i;

    /* Ignore words that are shorter than the minimum length */
    if (strlen(get_word(node, word)) < MIN_WORD_SIZE) return;

    /* Make even and odd words */
    for (i=0; word[i]; i++) {
        if (i & 1) *p_odd++ = word[i];
        else *p_even++ = word[i];
    }
    *p_odd = *p_even = '\0';

    /* If both words exist, this is an alternade */
    if (find_word(node->root, even) && find_word(node->root, odd)) {
        printf("%-20s%-10s%-10s\n", word, even, odd);
    }
}

int main(void) {
    struct trie_node *root = alloc_node();
    root->root = root;
    char word[WORD_BUF_SIZE], *nl;

    /* Read all words from stdin */
    while (!feof(stdin)) {
        fgets(word, WORD_BUF_SIZE, stdin);
        if (nl = strchr(word, '\n')) *nl = '\0'; /* remove newline */
        add_word(root, word);
    }

    /* Print all alternades */
    scan_trie(root, check_alternade);
    return 0;
}
