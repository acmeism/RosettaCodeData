// See https://en.wikipedia.org/wiki/Koch_snowflake
#include <fstream>
#include <iostream>
#include <vector>

constexpr double sqrt3_2 = 0.86602540378444; // sqrt(3)/2

struct point {
    double x;
    double y;
};

std::vector<point> koch_next(const std::vector<point>& points) {
    size_t size = points.size();
    std::vector<point> output(4*(size - 1) + 1);
    double x0, y0, x1, y1;
    size_t j = 0;
    for (size_t i = 0; i + 1 < size; ++i) {
        x0 = points[i].x;
        y0 = points[i].y;
        x1 = points[i + 1].x;
        y1 = points[i + 1].y;
        double dy = y1 - y0;
        double dx = x1 - x0;
        output[j++] = {x0, y0};
        output[j++] = {x0 + dx/3, y0 + dy/3};
        output[j++] = {x0 + dx/2 - dy * sqrt3_2/3, y0 + dy/2 + dx * sqrt3_2/3};
        output[j++] = {x0 + 2 * dx/3, y0 + 2 * dy/3};
    }
    output[j] = {x1, y1};
    return output;
}

std::vector<point> koch_points(int size, int iterations) {
    double length = size * sqrt3_2 * 0.95;
    double x = (size - length)/2;
    double y = size/2 - length * sqrt3_2/3;
    std::vector<point> points{
        {x, y},
        {x + length/2, y + length * sqrt3_2},
        {x + length, y},
        {x, y}
    };
    for (int i = 0; i < iterations; ++i)
        points = koch_next(points);
    return points;
}

void koch_curve_svg(std::ostream& out, int size, int iterations) {
    out << "<svg xmlns='http://www.w3.org/2000/svg' width='"
        << size << "' height='" << size << "'>\n";
    out << "<rect width='100%' height='100%' fill='black'/>\n";
    out << "<path stroke-width='1' stroke='white' fill='none' d='";
    auto points(koch_points(size, iterations));
    for (size_t i = 0, n = points.size(); i < n; ++i)
        out << (i == 0 ? "M" : "L") << points[i].x << ',' << points[i].y << '\n';
    out << "z'/>\n</svg>\n";
}

int main() {
    std::ofstream out("koch_curve.svg");
    if (!out) {
        std::cerr << "Cannot open output file\n";
        return EXIT_FAILURE;
    }
    koch_curve_svg(out, 600, 5);
    return EXIT_SUCCESS;
}
