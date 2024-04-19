#include <cctype>
#include <cstdlib>

bool isNumeric(const char *s) {
    if (s == nullptr || *s == '\0' || std::isspace(*s)) {
        return false;
    }
    char *p;
    std::strtod(s, &p);
    return *p == '\0';
}
