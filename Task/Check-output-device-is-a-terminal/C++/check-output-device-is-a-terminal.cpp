#if _WIN32
#include <io.h>
#define ISATTY _isatty
#define FILENO _fileno
#else
#include <unistd.h>
#define ISATTY isatty
#define FILENO fileno
#endif

#include <iostream>

int main() {
    if (ISATTY(FILENO(stdout))) {
        std::cout << "stdout is a tty\n";
    } else {
        std::cout << "stdout is not a tty\n";
    }

    return 0;
}
