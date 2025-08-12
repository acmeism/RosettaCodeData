#include <chrono>
#include <iostream>

int main() {
    std::cout << "The dates of the last Friday in each month of 2023:" << std::endl;
    using namespace std::literals;
    for ( auto ymd = std::chrono::Friday[std::chrono::last]/1/2023;
               ymd.year() < 2024y;
               ymd += std::chrono::months{1} )
        std::cout << std::chrono::sys_days{ymd} << '\n';
}
