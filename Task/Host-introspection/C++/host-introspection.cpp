#include <bit>
#include <iostream>

int main()
{
    std::cout << "int is " << sizeof(int) << " bytes\n";
    std::cout << "a pointer is " << sizeof(int*) << " bytes\n\n";

    if (std::endian::native == std::endian::big)
    {
        std::cout << "platform is big-endian\n";
    }
    else
    {
        std::cout << "host is little-endian\n";
    }
}
