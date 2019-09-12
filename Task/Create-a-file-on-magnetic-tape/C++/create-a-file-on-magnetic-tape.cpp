#include <iostream>
#include <fstream>

#if defined(_WIN32) || defined(WIN32)
constexpr auto FILENAME = "tape.file";
#else
constexpr auto FILENAME = "/dev/tape";
#endif

int main() {
    std::filebuf fb;
    fb.open(FILENAME,std::ios::out);
    std::ostream os(&fb);
    os << "Hello World\n";
    fb.close();
    return 0;
}
