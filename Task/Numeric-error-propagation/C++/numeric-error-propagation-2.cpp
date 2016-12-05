#include <cstdlib>
#include <iostream>
#include "numeric_error.hpp"

int main(const int argc, const char* argv[]) {
    const Approx x1(100, 1.1);
    const Approx x2(50, 1.2);
    const Approx y1(200, 2.2);
    const Approx y2(100, 2.3);
    std::cout << std::string(((x1 - x2).pow(2.) + (y1 - y2).pow(2.)).pow(0.5)) << std::endl; // => 111.803398874989 ±2.938366893361

	return EXIT_SUCCESS;
}
