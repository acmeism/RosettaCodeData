#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct node_t {
    char *elem;
    int length;
    struct node_t *next;
} node;

node *make_node(char *s) {
    node *t = malloc(sizeof(node));
    t->elem = s;
    t->length = strlen(s);
    t->next = NULL;
    return t;
}

void append_node(node *head, node *elem) {
    while (head->next != NULL) {
        head = head->next;
    }
    head->next = elem;
}

void print_node(node *n) {
    putc('[', stdout);
    while (n != NULL) {
        printf("`%s` ", n->elem);
        n = n->next;
    }
    putc(']', stdout);
}

char *lcs(node *list) {
    int minLen = INT_MAX;
    int i;

    char *res;
    node *ptr;

    if (list == NULL) {
        return "";
    }
    if (list->next == NULL) {
        return list->elem;
    }

    for (ptr = list; ptr != NULL; ptr = ptr->next) {
        minLen = min(minLen, ptr->length);
    }
    if (minLen == 0) {
        return "";
    }

    res = "";
    for (i = 1; i < minLen; i++) {
        char *suffix = &list->elem[list->length - i];

        for (ptr = list->next; ptr != NULL; ptr = ptr->next) {
            char *e = &ptr->elem[ptr->length - i];
            if (strcmp(suffix, e) != 0) {
                return res;
            }
        }

        res = suffix;
    }

    return res;
}

void test(node *n) {
    print_node(n);
    printf(" -> `%s`\n", lcs(n));
}

void case1() {
    node *n = make_node("baabababc");
    append_node(n, make_node("baabc"));
    append_node(n, make_node("bbbabc"));
    test(n);
}

void case2() {
    node *n = make_node("baabababc");
    append_node(n, make_node("baabc"));
    append_node(n, make_node("bbbazc"));
    test(n);
}

void case3() {
    node *n = make_node("Sunday");
    append_node(n, make_node("Monday"));
    append_node(n, make_node("Tuesday"));
    append_node(n, make_node("Wednesday"));
    append_node(n, make_node("Thursday"));
    append_node(n, make_node("Friday"));
    append_node(n, make_node("Saturday"));
    test(n);
}

void case4() {
    node *n = make_node("longest");
    append_node(n, make_node("common"));
    append_node(n, make_node("suffix"));
    test(n);
}

void case5() {
    node *n = make_node("suffix");
    test(n);
}

void case6() {
    node *n = make_node("");
    test(n);
}

int main() {
    case1();
    case2();
    case3();
    case4();
    case5();
    case6();
    return 0;
}
