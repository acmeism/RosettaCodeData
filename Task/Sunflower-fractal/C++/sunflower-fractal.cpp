#include <cmath>
#include <fstream>
#include <iostream>

bool sunflower(const char* filename) {
    std::ofstream out(filename);
    if (!out)
        return false;

    constexpr int size = 600;
    constexpr int seeds = 5 * size;
    constexpr double pi = 3.14159265359;
    constexpr double phi = 1.61803398875;

    out << "<svg xmlns='http://www.w3.org/2000/svg\' width='" << size;
    out << "' height='" << size << "' style='stroke:gold'>\n";
    out << "<rect width='100%' height='100%' fill='black'/>\n";
    out << std::setprecision(2) << std::fixed;
    for (int i = 1; i <= seeds; ++i) {
        double r = 2 * std::pow(i, phi)/seeds;
        double theta = 2 * pi * phi * i;
        double x = r * std::sin(theta) + size/2;
        double y = r * std::cos(theta) + size/2;
        double radius = std::sqrt(i)/13;
        out << "<circle cx='" << x << "' cy='" << y << "' r='" << radius << "'/>\n";
    }
    out << "</svg>\n";
    return true;
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        std::cerr << "usage: " << argv[0] << " filename\n";
        return EXIT_FAILURE;
    }
    if (!sunflower(argv[1])) {
        std::cerr << "image generation failed\n";
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
