#include <algorithm>
#include <array>
#include <filesystem>
#include <iomanip>
#include <iostream>

void file_size_distribution(const std::filesystem::path& directory) {
    constexpr size_t n = 9;
    constexpr std::array<std::uintmax_t, n> sizes = { 0, 1000, 10000,
        100000, 1000000, 10000000, 100000000, 1000000000, 10000000000 };
    std::array<size_t, n + 1> count = { 0 };
    size_t files = 0;
    std::uintmax_t total_size = 0;
    std::filesystem::recursive_directory_iterator iter(directory);
    for (const auto& dir_entry : iter) {
        if (dir_entry.is_regular_file() && !dir_entry.is_symlink()) {
            std::uintmax_t file_size = dir_entry.file_size();
            total_size += file_size;
            auto i = std::lower_bound(sizes.begin(), sizes.end(), file_size);
            size_t index = std::distance(sizes.begin(), i);
            ++count[index];
            ++files;
        }
    }
    std::cout << "File size distribution for " << directory << ":\n";
    for (size_t i = 0; i <= n; ++i) {
        if (i == n)
            std::cout << "> " << sizes[i - 1];
        else
            std::cout << std::setw(16) << sizes[i];
        std::cout << " bytes: " << count[i] << '\n';
    }
    std::cout << "Number of files: " << files << '\n';
    std::cout << "Total file size: " << total_size << " bytes\n";
}

int main(int argc, char** argv) {
    std::cout.imbue(std::locale(""));
    try {
        const char* directory(argc > 1 ? argv[1] : ".");
        std::filesystem::path path(directory);
        if (!is_directory(path)) {
            std::cerr << directory << " is not a directory.\n";
            return EXIT_FAILURE;
        }
        file_size_distribution(path);
    } catch (const std::exception& ex) {
        std::cerr << ex.what() << '\n';
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
