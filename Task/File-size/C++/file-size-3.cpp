#include <filesystem>
#include <iostream>

void print_file_size(const char* filename) {
    try {
        auto size = std::filesystem::file_size(filename);
        std::cout << "Size of file " << filename << " is " << size << " bytes.\n";
    } catch (const std::exception& ex) {
        std::cerr << ex.what() << '\n';
    }
}

int main() {
    print_file_size("input.txt");
    print_file_size("/input.txt");
}
