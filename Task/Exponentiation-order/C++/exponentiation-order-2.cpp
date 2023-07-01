#include <iostream>
#include <cmath>

enum my_int {};
inline my_int operator^(my_int a, my_int b) { return static_cast<my_int>(pow(a,b)); }

int main() {
    my_int x = 5, y = 3, z = 2;
    std::cout << "(5 ^ 3) ^ 2 = " << ((x^y)^z) << std::endl;
    std::cout << "5 ^ (3 ^ 2) = "<< (x^(y^z));
	
    return EXIT_SUCCESS;
}
