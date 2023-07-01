#include <stdio.h>

typedef struct {
    char *first, *last;
} Name;

Name whatsMyName() {
    return (Name) {
        .first = "James",
        .last = "Bond",
    };
}

int main() {
    Name me = whatsMyName();
    printf("The name's %s. %s %s.\n", me.last, me.first, me.last);
    return 0;
}
