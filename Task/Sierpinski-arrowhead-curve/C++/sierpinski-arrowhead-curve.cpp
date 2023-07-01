#include <fstream>
#include <iostream>
#include <vector>

constexpr double sqrt3_2 = 0.86602540378444; // sqrt(3)/2

struct point {
    double x;
    double y;
};

std::vector<point> sierpinski_arrowhead_next(const std::vector<point>& points) {
    size_t size = points.size();
    std::vector<point> output(3*(size - 1) + 1);
    double x0, y0, x1, y1;
    size_t j = 0;
    for (size_t i = 0; i + 1 < size; ++i, j += 3) {
        x0 = points[i].x;
        y0 = points[i].y;
        x1 = points[i + 1].x;
        y1 = points[i + 1].y;
        double dx = x1 - x0;
        output[j] = {x0, y0};
        if (y0 == y1) {
            double d = dx * sqrt3_2/2;
            if (d < 0) d = -d;
            output[j + 1] = {x0 + dx/4, y0 - d};
            output[j + 2] = {x1 - dx/4, y0 - d};
        } else if (y1 < y0) {
            output[j + 1] = {x1, y0};
            output[j + 2] = {x1 + dx/2, (y0 + y1)/2};
        } else {
            output[j + 1] = {x0 - dx/2, (y0 + y1)/2};
            output[j + 2] = {x0, y1};
        }
    }
    output[j] = {x1, y1};
    return output;
}

void write_sierpinski_arrowhead(std::ostream& out, int size, int iterations) {
    out << "<svg xmlns='http://www.w3.org/2000/svg' width='"
        << size << "' height='" << size << "'>\n";
    out << "<rect width='100%' height='100%' fill='white'/>\n";
    out << "<path stroke-width='1' stroke='black' fill='none' d='";
    const double margin = 20.0;
    const double side = size - 2.0 * margin;
    const double x = margin;
    const double y = 0.5 * size + 0.5 * sqrt3_2 * side;
    std::vector<point> points{{x, y}, {x + side, y}};
    for (int i = 0; i < iterations; ++i)
        points = sierpinski_arrowhead_next(points);
    for (size_t i = 0, n = points.size(); i < n; ++i)
        out << (i == 0 ? "M" : "L") << points[i].x << ',' << points[i].y << '\n';
    out << "'/>\n</svg>\n";
}

int main() {
    std::ofstream out("sierpinski_arrowhead.svg");
    if (!out) {
        std::cerr << "Cannot open output file\n";
        return EXIT_FAILURE;
    }
    write_sierpinski_arrowhead(out, 600, 8);
    return EXIT_SUCCESS;
}
