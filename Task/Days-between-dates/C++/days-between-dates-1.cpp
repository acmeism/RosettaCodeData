#include <chrono>
#include <iostream>

int main() {
    std::chrono::year_month_day date1{};
    std::chrono::year_month_day date2{};
    std::chrono::from_stream(std::cin, "%Y-%m-%d\n", date1);
    std::chrono::from_stream(std::cin, "%Y-%m-%d\n", date2);
    if (std::cin.fail()) {
        std::cout << "Dates are invalid.\n";
    }
    else {
        std::cout << "Days difference : "
                  << (static_cast<std::chrono::sys_days>(date2) - static_cast<std::chrono::sys_days>(date1)).count();
    }
}
