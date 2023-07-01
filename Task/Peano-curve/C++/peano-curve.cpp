#include <cmath>
#include <fstream>
#include <iostream>
#include <string>

class peano_curve {
public:
    void write(std::ostream& out, int size, int length, int order);
private:
    static std::string rewrite(const std::string& s);
    void line(std::ostream& out);
    void execute(std::ostream& out, const std::string& s);
    double x_;
    double y_;
    int angle_;
    int length_;
};

void peano_curve::write(std::ostream& out, int size, int length, int order) {
    length_ = length;
    x_ = length;
    y_ = length;
    angle_ = 90;
    out << "<svg xmlns='http://www.w3.org/2000/svg' width='"
        << size << "' height='" << size << "'>\n";
    out << "<rect width='100%' height='100%' fill='white'/>\n";
    out << "<path stroke-width='1' stroke='black' fill='none' d='";
    std::string s = "L";
    for (int i = 0; i < order; ++i)
        s = rewrite(s);
    execute(out, s);
    out << "'/>\n</svg>\n";
}

std::string peano_curve::rewrite(const std::string& s) {
    std::string t;
    for (char c : s) {
        switch (c) {
        case 'L':
            t += "LFRFL-F-RFLFR+F+LFRFL";
            break;
        case 'R':
            t += "RFLFR+F+LFRFL-F-RFLFR";
            break;
        default:
            t += c;
            break;
        }
    }
    return t;
}

void peano_curve::line(std::ostream& out) {
    double theta = (3.14159265359 * angle_)/180.0;
    x_ += length_ * std::cos(theta);
    y_ += length_ * std::sin(theta);
    out << " L" << x_ << ',' << y_;
}

void peano_curve::execute(std::ostream& out, const std::string& s) {
    out << 'M' << x_ << ',' << y_;
    for (char c : s) {
        switch (c) {
        case 'F':
            line(out);
            break;
        case '+':
            angle_ = (angle_ + 90) % 360;
            break;
        case '-':
            angle_ = (angle_ - 90) % 360;
            break;
        }
    }
}

int main() {
    std::ofstream out("peano_curve.svg");
    if (!out) {
        std::cerr << "Cannot open output file\n";
        return 1;
    }
    peano_curve pc;
    pc.write(out, 656, 8, 4);
    return 0;
}
