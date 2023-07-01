#include <iostream>

int main()
{
    int i, f = 2, b = 4;

    for ( i = 1 ; i <= 100 ; ++i, --f, --b )
    {
        if ( f && b ) { std::cout << i;             }
        if ( !f )     { std::cout << "Fizz"; f = 3; }
        if ( !b )     { std::cout << "Buzz"; b = 5; }
        std::cout << std::endl;
    }

    return 0;
}
