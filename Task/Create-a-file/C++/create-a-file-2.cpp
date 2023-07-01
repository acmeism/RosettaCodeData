#include <filesystem>
#include <fstream>

namespace fs = std::filesystem;

int main() {
    std::fstream f("output.txt", std::ios::out);
    f.close();
    f.open("/output.txt", std::ios::out);
    f.close();

    fs::create_directory("docs");
    fs::create_directory("/docs");
}
