#include <chrono>
#include <ranges>
#include <iostream>

int main() {
    std::cout << "Yuletide holidays must be allowed in the following years:\n";
    for (int year : std::views::iota(2008, 2121)
               | std::views::filter([](auto year) {
                    if (std::chrono::weekday{
                            std::chrono::year{year}/std::chrono::December/25}
                            == std::chrono::Sunday) {
                        return true;
                    }
                    return false;
                })) {
        std::cout << year << '\n';
    }
}
