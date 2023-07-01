#include <direct.h>
#include <fstream>

int main() {
    std::fstream f("output.txt", std::ios::out);
    f.close();
    f.open("/output.txt", std::ios::out);
    f.close();

    _mkdir("docs");
    _mkdir("/docs");

    return 0;
}
