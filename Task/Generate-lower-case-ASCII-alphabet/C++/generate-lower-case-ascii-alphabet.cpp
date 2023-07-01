#include <string>
#include <numeric>

int main() {
    std::string lower(26,' ');

    std::iota(lower.begin(), lower.end(), 'a');
}
