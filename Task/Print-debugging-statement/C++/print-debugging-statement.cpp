#include <iostream>

// requires support for variadic macros in this form
#define DEBUG(msg,...) fprintf(stderr, "[DEBUG %s@%d] " msg "\n", __FILE__, __LINE__, __VA_ARGS__)

// may be replace with and include of <source_location> (c++20) if it becomes part of the standard

int main() {
    DEBUG("Hello world");
    DEBUG("Some %d Things", 42);

    return 0;
}
