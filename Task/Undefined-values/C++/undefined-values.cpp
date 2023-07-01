#include <iostream>

int main()
{
    int undefined;
    if (undefined == 42)
    {
        std::cout << "42";
    }

    if (undefined != 42)
    {
        std::cout << "not 42";
    }
}
