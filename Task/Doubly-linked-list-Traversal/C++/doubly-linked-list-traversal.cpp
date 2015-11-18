#include <iostream>
#include <list>

int main ()
{
    std::list<int> numbers {1, 5, 7, 0, 3, 2};
    for(const auto& i: numbers)
        std::cout << i << ' ';
    std::cout << '\n';
}
