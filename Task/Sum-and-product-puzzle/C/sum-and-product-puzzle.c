#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct node_t {
    int x, y;
    struct node_t *prev, *next;
} node;

node *new_node(int x, int y) {
    node *n = malloc(sizeof(node));
    n->x = x;
    n->y = y;
    n->next = NULL;
    n->prev = NULL;
    return n;
}

void free_node(node **n) {
    if (n == NULL) {
        return;
    }

    (*n)->prev = NULL;
    (*n)->next = NULL;

    free(*n);

    *n = NULL;
}

typedef struct list_t {
    node *head;
    node *tail;
} list;

list make_list() {
    list lst = { NULL, NULL };
    return lst;
}

void append_node(list *const lst, int x, int y) {
    if (lst == NULL) {
        return;
    }

    node *n = new_node(x, y);

    if (lst->head == NULL) {
        lst->head = n;
        lst->tail = n;
    } else {
        n->prev = lst->tail;
        lst->tail->next = n;
        lst->tail = n;
    }
}

void remove_node(list *const lst, const node *const n) {
    if (lst == NULL || n == NULL) {
        return;
    }

    if (n->prev != NULL) {
        n->prev->next = n->next;
        if (n->next != NULL) {
            n->next->prev = n->prev;
        } else {
            lst->tail = n->prev;
        }
    } else {
        if (n->next != NULL) {
            n->next->prev = NULL;
            lst->head = n->next;
        }
    }

    free_node(&n);
}

void free_list(list *const lst) {
    node *ptr;

    if (lst == NULL) {
        return;
    }
    ptr = lst->head;

    while (ptr != NULL) {
        node *nxt = ptr->next;
        free_node(&ptr);
        ptr = nxt;
    }

    lst->head = NULL;
    lst->tail = NULL;
}

void print_list(const list *lst) {
    node *it;

    if (lst == NULL) {
        return;
    }

    for (it = lst->head; it != NULL; it = it->next) {
        int sum = it->x + it->y;
        int prod = it->x * it->y;
        printf("[%d, %d] S=%d P=%d\n", it->x, it->y, sum, prod);
    }
}

void print_count(const list *const lst) {
    node *it;
    int c = 0;

    if (lst == NULL) {
        return;
    }

    for (it = lst->head; it != NULL; it = it->next) {
        c++;
    }

    if (c == 0) {
        printf("no candidates\n");
    } else    if (c == 1) {
        printf("one candidate\n");
    } else {
        printf("%d candidates\n", c);
    }
}

void setup(list *const lst) {
    int x, y;

    if (lst == NULL) {
        return;
    }

    // numbers must be greater than 1
    for (x = 2; x <= 98; x++) {
        // numbers must be unique, and sum no more than 100
        for (y = x + 1; y <= 98; y++) {
            if (x + y <= 100) {
                append_node(lst, x, y);
            }
        }
    }
}

void remove_by_sum(list *const lst, const int sum) {
    node *it;

    if (lst == NULL) {
        return;
    }

    it = lst->head;
    while (it != NULL) {
        int s = it->x + it->y;

        if (s == sum) {
            remove_node(lst, it);
            it = lst->head;
        } else {
            it = it->next;
        }
    }
}

void remove_by_prod(list *const lst, const int prod) {
    node *it;

    if (lst == NULL) {
        return;
    }

    it = lst->head;
    while (it != NULL) {
        int p = it->x * it->y;

        if (p == prod) {
            remove_node(lst, it);
            it = lst->head;
        } else {
            it = it->next;
        }
    }
}

void statement1(list *const lst) {
    short *unique = calloc(100000, sizeof(short));
    node *it, *nxt;

    for (it = lst->head; it != NULL; it = it->next) {
        int prod = it->x * it->y;
        unique[prod]++;
    }

    it = lst->head;
    while (it != NULL) {
        int prod = it->x * it->y;
        nxt = it->next;
        if (unique[prod] == 1) {
            remove_by_sum(lst, it->x + it->y);
            it = lst->head;
        } else {
            it = nxt;
        }
    }

    free(unique);
}

void statement2(list *const candidates) {
    short *unique = calloc(100000, sizeof(short));
    node *it, *nxt;

    for (it = candidates->head; it != NULL; it = it->next) {
        int prod = it->x * it->y;
        unique[prod]++;
    }

    it = candidates->head;
    while (it != NULL) {
        int prod = it->x * it->y;
        nxt = it->next;
        if (unique[prod] > 1) {
            remove_by_prod(candidates, prod);
            it = candidates->head;
        } else {
            it = nxt;
        }
    }

    free(unique);
}

void statement3(list *const candidates) {
    short *unique = calloc(100, sizeof(short));
    node *it, *nxt;

    for (it = candidates->head; it != NULL; it = it->next) {
        int sum = it->x + it->y;
        unique[sum]++;
    }

    it = candidates->head;
    while (it != NULL) {
        int sum = it->x + it->y;
        nxt = it->next;
        if (unique[sum] > 1) {
            remove_by_sum(candidates, sum);
            it = candidates->head;
        } else {
            it = nxt;
        }
    }

    free(unique);
}

int main() {
    list candidates = make_list();

    setup(&candidates);
    print_count(&candidates);

    statement1(&candidates);
    print_count(&candidates);

    statement2(&candidates);
    print_count(&candidates);

    statement3(&candidates);
    print_count(&candidates);

    print_list(&candidates);

    free_list(&candidates);
    return 0;
}
