#include <iostream>
#include <forward_list>

int main()
{
    std::forward_list<int> list{1, 2, 3, 4, 5};
    for (int e : list)
        std::cout << e << std::endl;
}
