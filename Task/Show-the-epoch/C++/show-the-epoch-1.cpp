#include <iostream>
#include <chrono>
#include <ctime>
int main()
{
    std::chrono::system_clock::time_point epoch;
    std::time_t t = std::chrono::system_clock::to_time_t(epoch);
    std::cout << std::asctime(std::gmtime(&t)) << '\n';
    return 0;
}
