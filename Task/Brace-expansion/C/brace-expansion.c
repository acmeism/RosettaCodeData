#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFFER_SIZE 128

typedef unsigned char character;
typedef character *string;

typedef struct node_t node;
struct node_t {
    enum tag_t {
        NODE_LEAF,
        NODE_TREE,
        NODE_SEQ,
    } tag;

    union {
        string str;
        node *root;
    } data;

    node *next;
};

node *allocate_node(enum tag_t tag) {
    node *n = malloc(sizeof(node));
    if (n == NULL) {
        fprintf(stderr, "Failed to allocate node for tag: %d\n", tag);
        exit(1);
    }
    n->tag = tag;
    n->next = NULL;
    return n;
}

node *make_leaf(string str) {
    node *n = allocate_node(NODE_LEAF);
    n->data.str = str;
    return n;
}

node *make_tree() {
    node *n = allocate_node(NODE_TREE);
    n->data.root = NULL;
    return n;
}

node *make_seq() {
    node *n = allocate_node(NODE_SEQ);
    n->data.root = NULL;
    return n;
}

void deallocate_node(node *n) {
    if (n == NULL) {
        return;
    }

    deallocate_node(n->next);
    n->next = NULL;

    if (n->tag == NODE_LEAF) {
        free(n->data.str);
        n->data.str = NULL;
    } else if (n->tag == NODE_TREE || n->tag == NODE_SEQ) {
        deallocate_node(n->data.root);
        n->data.root = NULL;
    } else {
        fprintf(stderr, "Cannot deallocate node with tag: %d\n", n->tag);
        exit(1);
    }

    free(n);
}

void append(node *root, node *elem) {
    if (root == NULL) {
        fprintf(stderr, "Cannot append to uninitialized node.");
        exit(1);
    }
    if (elem == NULL) {
        return;
    }

    if (root->tag == NODE_SEQ || root->tag == NODE_TREE) {
        if (root->data.root == NULL) {
            root->data.root = elem;
        } else {
            node *it = root->data.root;
            while (it->next != NULL) {
                it = it->next;
            }
            it->next = elem;
        }
    } else {
        fprintf(stderr, "Cannot append to node with tag: %d\n", root->tag);
        exit(1);
    }
}

size_t count(node *n) {
    if (n == NULL) {
        return 0;
    }

    if (n->tag == NODE_LEAF) {
        return 1;
    }
    if (n->tag == NODE_TREE) {
        size_t sum = 0;
        node *it = n->data.root;
        while (it != NULL) {
            sum += count(it);
            it = it->next;
        }
        return sum;
    }
    if (n->tag == NODE_SEQ) {
        size_t prod = 1;
        node *it = n->data.root;
        while (it != NULL) {
            prod *= count(it);
            it = it->next;
        }
        return prod;
    }

    fprintf(stderr, "Cannot count node with tag: %d\n", n->tag);
    exit(1);
}

void expand(node *n, size_t pos) {
    if (n == NULL) {
        return;
    }

    if (n->tag == NODE_LEAF) {
        printf(n->data.str);
    } else if (n->tag == NODE_TREE) {
        node *it = n->data.root;
        while (true) {
            size_t cnt = count(it);
            if (pos < cnt) {
                expand(it, pos);
                break;
            }
            pos -= cnt;
            it = it->next;
        }
    } else if (n->tag == NODE_SEQ) {
        size_t prod = pos;
        node *it = n->data.root;
        while (it != NULL) {
            size_t cnt = count(it);

            size_t rem = prod % cnt;
            expand(it, rem);

            it = it->next;
        }
    } else {
        fprintf(stderr, "Cannot expand node with tag: %d\n", n->tag);
        exit(1);
    }
}

string allocate_string(string src) {
    size_t len = strlen(src);
    string out = calloc(len + 1, sizeof(character));
    if (out == NULL) {
        fprintf(stderr, "Failed to allocate a copy of the string.");
        exit(1);
    }
    strcpy(out, src);
    return out;
}

node *parse_seq(string input, size_t *pos);

node *parse_tree(string input, size_t *pos) {
    node *root = make_tree();

    character buffer[BUFFER_SIZE] = { 0 };
    size_t bufpos = 0;
    size_t depth = 0;
    bool asSeq = false;
    bool allow = false;

    while (input[*pos] != 0) {
        character c = input[(*pos)++];
        if (c == '\\') {
            c = input[(*pos)++];
            if (c == 0) {
                break;
            }
            buffer[bufpos++] = '\\';
            buffer[bufpos++] = c;
            buffer[bufpos] = 0;
        } else if (c == '{') {
            buffer[bufpos++] = c;
            buffer[bufpos] = 0;
            asSeq = true;
            depth++;
        } else if (c == '}') {
            if (depth-- > 0) {
                buffer[bufpos++] = c;
                buffer[bufpos] = 0;
            } else {
                if (asSeq) {
                    size_t new_pos = 0;
                    node *seq = parse_seq(buffer, &new_pos);
                    append(root, seq);
                } else {
                    append(root, make_leaf(allocate_string(buffer)));
                }
                break;
            }
        } else if (c == ',') {
            if (depth == 0) {
                if (asSeq) {
                    size_t new_pos = 0;
                    node *seq = parse_seq(buffer, &new_pos);
                    append(root, seq);
                    bufpos = 0;
                    buffer[bufpos] = 0;
                    asSeq = false;
                } else {
                    append(root, make_leaf(allocate_string(buffer)));
                    bufpos = 0;
                    buffer[bufpos] = 0;
                }
            } else {
                buffer[bufpos++] = c;
                buffer[bufpos] = 0;
            }
        } else {
            buffer[bufpos++] = c;
            buffer[bufpos] = 0;
        }
    }

    return root;
}

node *parse_seq(string input, size_t *pos) {
    node *root = make_seq();

    character buffer[BUFFER_SIZE] = { 0 };
    size_t bufpos = 0;

    while (input[*pos] != 0) {
        character c = input[(*pos)++];
        if (c == '\\') {
            c = input[(*pos)++];
            if (c == 0) {
                break;
            }
            buffer[bufpos++] = c;
            buffer[bufpos] = 0;
        } else if (c == '{') {
            node *tree = parse_tree(input, pos);
            if (bufpos > 0) {
                append(root, make_leaf(allocate_string(buffer)));
                bufpos = 0;
                buffer[bufpos] = 0;
            }
            append(root, tree);
        } else {
            buffer[bufpos++] = c;
            buffer[bufpos] = 0;
        }
    }

    if (bufpos > 0) {
        append(root, make_leaf(allocate_string(buffer)));
        bufpos = 0;
        buffer[bufpos] = 0;
    }

    return root;
}

void test(string input) {
    size_t pos = 0;
    node *n = parse_seq(input, &pos);
    size_t cnt = count(n);
    size_t i;

    printf("Pattern: %s\n", input);

    for (i = 0; i < cnt; i++) {
        expand(n, i);
        printf("\n");
    }
    printf("\n");

    deallocate_node(n);
}

int main() {
    test("~/{Downloads,Pictures}/*.{jpg,gif,png}");
    test("It{{em,alic}iz,erat}e{d,}, please.");
    test("{,{,gotta have{ ,\\, again\\, }}more }cowbell!");

    //not sure how to parse this one
    //test("{}} some }{,{\\{ edge, edge} \,}{ cases, {here} \\\\\}");

    return 0;
}
