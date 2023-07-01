#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct lnode_t {
    struct lnode_t *prev;
    struct lnode_t *next;
    int v;
} Lnode;

Lnode *make_list_node(int v) {
    Lnode *node = malloc(sizeof(Lnode));
    if (node == NULL) {
        return NULL;
    }
    node->v = v;
    node->prev = NULL;
    node->next = NULL;
    return node;
}

void free_lnode(Lnode *node) {
    if (node == NULL) {
        return;
    }

    node->v = 0;
    node->prev = NULL;
    free_lnode(node->next);
    node->next = NULL;
}

typedef struct list_t {
    Lnode *front;
    Lnode *back;
    size_t len;
} List;

List *make_list() {
    List *list = malloc(sizeof(List));
    if (list == NULL) {
        return NULL;
    }
    list->front = NULL;
    list->back = NULL;
    list->len = 0;
    return list;
}

void free_list(List *list) {
    if (list == NULL) {
        return;
    }
    list->len = 0;
    list->back = NULL;
    free_lnode(list->front);
    list->front = NULL;
}

void list_insert(List *list, int v) {
    Lnode *node;

    if (list == NULL) {
        return;
    }

    node = make_list_node(v);
    if (list->front == NULL) {
        list->front = node;
        list->back = node;
        list->len = 1;
    } else {
        node->prev = list->back;
        list->back->next = node;
        list->back = node;
        list->len++;
    }
}

void list_print(List *list) {
    Lnode *it;

    if (list == NULL) {
        return;
    }

    for (it = list->front; it != NULL; it = it->next) {
        printf("%d ", it->v);
    }
}

int list_get(List *list, int idx) {
    Lnode *it = NULL;

    if (list != NULL && list->front != NULL) {
        int i;
        if (idx < 0) {
            it = list->back;
            i = -1;
            while (it != NULL && i > idx) {
                it = it->prev;
                i--;
            }
        } else {
            it = list->front;
            i = 0;
            while (it != NULL && i < idx) {
                it = it->next;
                i++;
            }
        }
    }

    if (it == NULL) {
        return INT_MIN;
    }
    return it->v;
}

///////////////////////////////////////

typedef struct mnode_t {
    int k;
    bool v;
    struct mnode_t *next;
} Mnode;

Mnode *make_map_node(int k, bool v) {
    Mnode *node = malloc(sizeof(Mnode));
    if (node == NULL) {
        return node;
    }
    node->k = k;
    node->v = v;
    node->next = NULL;
    return node;
}

void free_mnode(Mnode *node) {
    if (node == NULL) {
        return;
    }
    node->k = 0;
    node->v = false;
    free_mnode(node->next);
    node->next = NULL;
}

typedef struct map_t {
    Mnode *front;
} Map;

Map *make_map() {
    Map *map = malloc(sizeof(Map));
    if (map == NULL) {
        return NULL;
    }
    map->front = NULL;
    return map;
}

void free_map(Map *map) {
    if (map == NULL) {
        return;
    }
    free_mnode(map->front);
    map->front = NULL;
}

void map_insert(Map *map, int k, bool v) {
    if (map == NULL) {
        return;
    }
    if (map->front == NULL) {
        map->front = make_map_node(k, v);
    } else {
        Mnode *it = map->front;
        while (it->next != NULL) {
            it = it->next;
        }
        it->next = make_map_node(k, v);
    }
}

bool map_get(Map *map, int k) {
    if (map != NULL) {
        Mnode *it = map->front;
        while (it != NULL && it->k != k) {
            it = it->next;
        }
        if (it != NULL) {
            return it->v;
        }
    }
    return false;
}

///////////////////////////////////////

int gcd(int u, int v) {
    if (u < 0) u = -u;
    if (v < 0) v = -v;
    if (v) {
        while ((u %= v) && (v %= u));
    }
    return u + v;
}

List *yellow(size_t n) {
    List *a;
    Map *b;
    int i;

    a = make_list();
    list_insert(a, 1);
    list_insert(a, 2);
    list_insert(a, 3);

    b = make_map();
    map_insert(b, 1, true);
    map_insert(b, 2, true);
    map_insert(b, 3, true);

    i = 4;

    while (n > a->len) {
        if (!map_get(b, i) && gcd(i, list_get(a, -1)) == 1 && gcd(i, list_get(a, -2)) > 1) {
            list_insert(a, i);
            map_insert(b, i, true);
            i = 4;
        }
        i++;
    }

    free_map(b);
    return a;
}

int main() {
    List *a = yellow(30);
    list_print(a);
    free_list(a);
    putc('\n', stdout);
    return 0;
}
