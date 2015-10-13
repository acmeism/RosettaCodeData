#include <iostream>
#include <list>

int main ()
{
    std::list<int> numbers {1, 5, 7, 0, 3, 2};
    numbers.insert(numbers.begin(), 9); //Insert at the beginning
    numbers.insert(numbers.end(), 4); //Insert at the end
    auto it = std::next(numbers.begin(), numbers.size() / 2); //Iterator to the middle of the list
    numbers.insert(it, 6); //Insert in the middle
    for(const auto& i: numbers)
        std::cout << i << ' ';
    std::cout << '\n';
}
