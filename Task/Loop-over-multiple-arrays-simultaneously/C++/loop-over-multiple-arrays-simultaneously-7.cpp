#include <array>
#include <ranges>
#include <format>
#include <iostream>

int main() {
    auto a1 = std::array{"a", "b", "c"};
    auto a2 = std::array{"A", "B", "C"};
    auto a3 = std::array{1, 2, 3};

    for(const auto& [x, y, z] : std::ranges::views::zip(a1, a2, a3))
    {
        std::cout << std::format("{}{}{}\n", x, y, z);
    }
}
