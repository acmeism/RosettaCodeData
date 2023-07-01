#include <iostream>
#include <thread>
#include <chrono>
int main()
{
    unsigned long microseconds;
    std::cin >> microseconds;
    std::cout << "Sleeping..." << std::endl;
    std::this_thread::sleep_for(std::chrono::microseconds(microseconds));
    std::cout << "Awake!\n";
}
