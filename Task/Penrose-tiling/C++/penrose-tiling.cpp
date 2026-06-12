#include <cmath>
#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <set>
#include <sstream>
#include <stack>
#include <string>
#include <tuple>

int main() {
    std::ofstream out("penrose_tiling.svg");
    if (!out) {
        std::cerr << "Cannot open output file.\n";
        return EXIT_FAILURE;
    }
    std::string penrose("[N]++[N]++[N]++[N]++[N]");
    for (int i = 1; i <= 4; ++i) {
        std::string next;
        for (char ch : penrose) {
            switch (ch) {
            case 'A':
                break;
            case 'M':
                next += "OA++PA----NA[-OA----MA]++";
                break;
            case 'N':
                next += "+OA--PA[---MA--NA]+";
                break;
            case 'O':
                next += "-MA++NA[+++OA++PA]-";
                break;
            case 'P':
                next += "--OA++++MA[+PA++++NA]--NA";
                break;
            default:
                next += ch;
                break;
            }
        }
        penrose = std::move(next);
    }
    const double r = 30;
    const double pi5 = 0.628318530717959;
    double x = r * 8, y = r * 8, theta = pi5;
    std::set<std::string> svg;
    std::stack<std::tuple<double, double, double>> stack;
    for (char ch : penrose) {
        switch (ch) {
        case 'A': {
            double nx = x + r * std::cos(theta);
            double ny = y + r * std::sin(theta);
            std::ostringstream line;
            line << std::fixed << std::setprecision(3) << "<line x1='" << x
                 << "' y1='" << y << "' x2='" << nx << "' y2='" << ny << "'/>";
            svg.insert(line.str());
            x = nx;
            y = ny;
        } break;
        case '+':
            theta += pi5;
            break;
        case '-':
            theta -= pi5;
            break;
        case '[':
            stack.push({x, y, theta});
            break;
        case ']':
            std::tie(x, y, theta) = stack.top();
            stack.pop();
            break;
        }
    }
    out << "<svg xmlns='http://www.w3.org/2000/svg' height='" << r * 16
        << "' width='" << r * 16 << "'>\n"
        << "<rect height='100%' width='100%' fill='black'/>\n"
        << "<g stroke='rgb(255,165,0)'>\n";
    for (const auto& line : svg)
        out << line << '\n';
    out << "</g>\n</svg>\n";
    return EXIT_SUCCESS;
}
