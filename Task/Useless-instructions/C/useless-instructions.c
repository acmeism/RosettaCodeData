#include <stdio.h>
#include <stdbool.h>

void uselessFunc(int uselessParam) { // parameter required but never used
    auto int i; // auto redundant

    if (true) {
        // do something
    } else {
        printf("Never called\n");
    }

    for (i = 0; i < 0; ++i) {
        printf("Never called\n");
    }

    while (false) {
        printf("Never called\n");
    }

    printf(""); // no visible effect but gcc 9.3.0 warns against it

    return; // redundant as function would return 'naturally' anyway
}

struct UselessStruct {
    // no fields so effectively useless and apparently non-standard in any case
};

int main() {
    uselessFunc(0);
    printf("Working OK.\n");
}
