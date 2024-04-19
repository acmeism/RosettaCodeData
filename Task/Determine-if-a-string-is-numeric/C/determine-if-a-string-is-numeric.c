#include <ctype.h>
#include <stdbool.h>
#include <stdlib.h>

bool isNumeric(const char *s) {
    if (s == NULL || *s == '\0' || isspace(*s)) {
        return false;
    }
    char *p;
    strtod(s, &p);
    return *p == '\0';
}
