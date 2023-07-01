#include <iostream>
#include <cmath>

int main() {
    std::cout << "(5 ^ 3) ^ 2 = " << (uint) pow(pow(5,3), 2) << std::endl;
    std::cout << "5 ^ (3 ^ 2) = "<< (uint) pow(5, (pow(3, 2)));
	
    return EXIT_SUCCESS;
}
