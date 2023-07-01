#include <stdbool.h>
#include <string.h>

static bool
strings_are_equal(const char **strings, size_t nstrings)
{
    for (size_t i = 1; i < nstrings; i++)
        if (strcmp(strings[0], strings[i]) != 0)
            return false;
    return true;
}

static bool
strings_are_in_ascending_order(const char **strings, size_t nstrings)
{
    for (size_t i = 1; i < nstrings; i++)
        if (strcmp(strings[i - 1], strings[i]) >= 0)
            return false;
    return true;
}
