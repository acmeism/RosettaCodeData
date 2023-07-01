#include <array>
#include <iostream>
#include <string>

int main()
{
    std::array<std::string, 2> fruit { "apples", "oranges" };
    std::cout << fruit.size();
    return 0;
}
