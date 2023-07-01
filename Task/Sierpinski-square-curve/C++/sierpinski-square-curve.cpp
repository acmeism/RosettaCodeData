// See https://en.wikipedia.org/wiki/Sierpi%C5%84ski_curve#Representation_as_Lindenmayer_system
#include <cmath>
#include <fstream>
#include <iostream>
#include <string>

class sierpinski_square {
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

void sierpinski_square::write(std::ostream& out, int size, int length, int order) {
    length_ = length;
    x_ = (size - length)/2;
    y_ = length;
    angle_ = 0;
    out << "<svg xmlns='http://www.w3.org/2000/svg' width='"
        << size << "' height='" << size << "'>\n";
    out << "<rect width='100%' height='100%' fill='white'/>\n";
    out << "<path stroke-width='1' stroke='black' fill='none' d='";
    std::string s = "F+XF+F+XF";
    for (int i = 0; i < order; ++i)
        s = rewrite(s);
    execute(out, s);
    out << "'/>\n</svg>\n";
}

std::string sierpinski_square::rewrite(const std::string& s) {
    std::string t;
    for (char c : s) {
        if (c == 'X')
            t += "XF-F+F-XF+F+XF-F+F-X";
        else
            t += c;
    }
    return t;
}

void sierpinski_square::line(std::ostream& out) {
    double theta = (3.14159265359 * angle_)/180.0;
    x_ += length_ * std::cos(theta);
    y_ += length_ * std::sin(theta);
    out << " L" << x_ << ',' << y_;
}

void sierpinski_square::execute(std::ostream& out, const std::string& s) {
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
    std::ofstream out("sierpinski_square.svg");
    if (!out) {
        std::cerr << "Cannot open output file\n";
        return 1;
    }
    sierpinski_square s;
    s.write(out, 635, 5, 5);
    return 0;
}
