#include <stdio.h>
#include <string.h>

int count_jewels(const char *s, const char *j) {
    int count = 0;
    for ( ; *s; ++s) if (strchr(j, *s)) ++count;
    return count;
}

int main() {
    printf("%d\n", count_jewels("aAAbbbb", "aA"));
    printf("%d\n", count_jewels("ZZ", "z"));
    return 0;
}
