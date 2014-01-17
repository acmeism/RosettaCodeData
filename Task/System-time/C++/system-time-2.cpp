#include <chrono>
#include <ctime> //for conversion std::ctime()
#include <iostream>

int main() {
    auto timenow = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
    std::cout << std::ctime(&timenow) << std::endl;
}
