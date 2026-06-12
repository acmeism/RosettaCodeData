#include <stdio.h>

typedef enum {
    PARENT,
    CHILD
} typeid;

typedef struct {
    const char* name;
    int age;
} parent;

typedef struct {
    parent p;
} child;

void watchMovie(parent *p, typeid id) {
    if (id == CHILD && p->age < 15) {
        printf("Sorry, %s, you are too young to watch the movie.\n", p->name);
    } else {
        printf("%s is watching the movie...\n", p->name);
    }
}
int main() {
    parent p = { "Donald", 42 };
    child c1 = { "Lisa", 18 };
    child c2 = { "Fred", 10 };
    watchMovie(&p, PARENT);
    watchMovie(&c1.p, CHILD);
    watchMovie(&c2.p, CHILD);
    return 0;
}
