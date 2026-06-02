#include <print>
#include <ranges>
#include <flat_map>
#include <string_view>

constexpr void gFizzBuzz(int max, const std::flat_map<int, std::string_view>& map) noexcept {
    for (const auto num : std::views::iota(1, max + 1)) {
        bool print_number = true;
        for (const auto [i, word] : map) {
            if (num % i == 0) {
                std::print("{}", word);
                print_number = false;
            }
        }

        if (print_number) {
            std::print("{}", num);
        }
        std::println();
    }
}

int main() {
    std::flat_map<int, std::string_view> values {
        { 7, "Baxx" },
        { 3, "Fizz" },
        { 5, "Buzz" }
    };
    gFizzBuzz(20, values);
}
