#include <iostream>
#include <string>
#include <random>

int main()
{
    std::random_device rd;
    std::uniform_int_distribution<int> dist;

    std::cout << "Random Number: " << dist(rd) << std::endl;
}
