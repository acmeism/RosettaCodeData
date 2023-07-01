#include <stdio.h>
#include <stdbool.h>

extern bool query(char *data, size_t *length);

int main() {
    char buffer[1024];
    size_t size = sizeof(buffer);

    if (query(buffer, &size))
        printf("%.*s\n", size, buffer);
    else
        puts("The call to query has failed.");

    return 0;
}
