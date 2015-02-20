#include <iostream>
#include <random>

int main()
{
    std::random_device rd;
    std::uniform_int_distribution<long> dist; // long is guaranteed to be 32 bits

    std::cout << "Random Number: " << dist(rd) << std::endl;
}
