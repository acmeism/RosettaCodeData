#include <stdio.h>
#include <stdlib.h>
#include <time.h>

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

typedef struct node_tag {
    int item;
    struct node_tag* prev;
    struct node_tag* next;
} node_t;

void list_initialize(node_t* list) {
    list->prev = list;
    list->next = list;
}

void list_destroy(node_t* list) {
    node_t* n = list->next;
    while (n != list) {
        node_t* tmp = n->next;
        free(n);
        n = tmp;
    }
}

void list_append_node(node_t* list, node_t* node) {
    node_t* prev = list->prev;
    prev->next = node;
    list->prev = node;
    node->prev = prev;
    node->next = list;
}

void list_append_item(node_t* list, int item) {
    node_t* node = xmalloc(sizeof(node_t));
    node->item = item;
    list_append_node(list, node);
}

void list_print(node_t* list) {
    printf("[");
    node_t* n = list->next;
    if (n != list) {
        printf("%d", n->item);
        n = n->next;
    }
    for (; n != list; n = n->next)
        printf(", %d", n->item);
    printf("]\n");
}

void tree_insert(node_t** p, node_t* n) {
    while (*p != NULL) {
        if (n->item < (*p)->item)
            p = &(*p)->prev;
        else
            p = &(*p)->next;
    }
    *p = n;
}

void tree_to_list(node_t* list, node_t* node) {
    if (node == NULL)
        return;
    node_t* prev = node->prev;
    node_t* next = node->next;
    tree_to_list(list, prev);
    list_append_node(list, node);
    tree_to_list(list, next);
}

void tree_sort(node_t* list) {
    node_t* n = list->next;
    if (n == list)
        return;
    node_t* root = NULL;
    while (n != list) {
        node_t* next = n->next;
        n->next = n->prev = NULL;
        tree_insert(&root, n);
        n = next;
    }
    list_initialize(list);
    tree_to_list(list, root);
}

int main() {
    srand(time(0));
    node_t list;
    list_initialize(&list);
    for (int i = 0; i < 16; ++i)
        list_append_item(&list, rand() % 100);
    printf("before sort: ");
    list_print(&list);
    tree_sort(&list);
    printf(" after sort: ");
    list_print(&list);
    list_destroy(&list);
    return 0;
}
