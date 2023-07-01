#include <algorithm>
#include <cctype>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

bool endsWithIgnoreCase(const std::string& str, const std::string& suffix) {
    const size_t n1 = str.length();
    const size_t n2 = suffix.length();
    if (n1 < n2)
        return false;
    return std::equal(str.begin() + (n1 - n2), str.end(), suffix.begin(),
        [](char c1, char c2) {
            return std::tolower(static_cast<unsigned char>(c1))
                == std::tolower(static_cast<unsigned char>(c2));
    });
}

bool filenameHasExtension(const std::string& filename,
                          const std::vector<std::string>& extensions) {
    return std::any_of(extensions.begin(), extensions.end(),
        [&filename](const std::string& extension) {
            return endsWithIgnoreCase(filename, "." + extension);
    });
}

void test(const std::string& filename,
          const std::vector<std::string>& extensions) {
    std::cout << std::setw(20) << std::left << filename
        << ": " << std::boolalpha
        << filenameHasExtension(filename, extensions) << '\n';
}

int main() {
    const std::vector<std::string> extensions{"zip", "rar", "7z",
        "gz", "archive", "A##", "tar.bz2"};
    test("MyData.a##", extensions);
    test("MyData.tar.Gz", extensions);
    test("MyData.gzip", extensions);
    test("MyData.7z.backup", extensions);
    test("MyData...", extensions);
    test("MyData", extensions);
    test("MyData_v1.0.tar.bz2", extensions);
    test("MyData_v1.0.bz2", extensions);
    return 0;
}
