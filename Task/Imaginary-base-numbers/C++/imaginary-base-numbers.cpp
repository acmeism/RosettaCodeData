#include <algorithm>
#include <complex>
#include <iomanip>
#include <iostream>

std::complex<double> inv(const std::complex<double>& c) {
    double denom = c.real() * c.real() + c.imag() * c.imag();
    return std::complex<double>(c.real() / denom, -c.imag() / denom);
}

class QuaterImaginary {
public:
    QuaterImaginary(const std::string& s) : b2i(s) {
        static std::string base("0123.");

        if (b2i.empty()
            || std::any_of(s.cbegin(), s.cend(), [](char c) { return base.find(c) == std::string::npos; })
            || std::count(s.cbegin(), s.cend(), '.') > 1) {
            throw std::runtime_error("Invalid base 2i number");
        }
    }

    QuaterImaginary& operator=(const QuaterImaginary& q) {
        b2i = q.b2i;
        return *this;
    }

    std::complex<double> toComplex() const {
        int pointPos = b2i.find('.');
        int posLen = (pointPos != std::string::npos) ? pointPos : b2i.length();
        std::complex<double> sum(0.0, 0.0);
        std::complex<double> prod(1.0, 0.0);
        for (int j = 0; j < posLen; j++) {
            double k = (b2i[posLen - 1 - j] - '0');
            if (k > 0.0) {
                sum += prod * k;
            }
            prod *= twoI;
        }
        if (pointPos != -1) {
            prod = invTwoI;
            for (size_t j = posLen + 1; j < b2i.length(); j++) {
                double k = (b2i[j] - '0');
                if (k > 0.0) {
                    sum += prod * k;
                }
                prod *= invTwoI;
            }
        }

        return sum;
    }

    friend std::ostream& operator<<(std::ostream&, const QuaterImaginary&);

private:
    const std::complex<double> twoI{ 0.0, 2.0 };
    const std::complex<double> invTwoI = inv(twoI);

    std::string b2i;
};

std::ostream& operator<<(std::ostream& os, const QuaterImaginary& q) {
    return os << q.b2i;
}

// only works properly if 'real' and 'imag' are both integral
QuaterImaginary toQuaterImaginary(const std::complex<double>& c) {
    if (c.real() == 0.0 && c.imag() == 0.0) return QuaterImaginary("0");

    int re = (int)c.real();
    int im = (int)c.imag();
    int fi = -1;
    std::stringstream ss;
    while (re != 0) {
        int rem = re % -4;
        re /= -4;
        if (rem < 0) {
            rem = 4 + rem;
            re++;
        }
        ss << rem << 0;
    }
    if (im != 0) {
        double f = (std::complex<double>(0.0, c.imag()) / std::complex<double>(0.0, 2.0)).real();
        im = (int)ceil(f);
        f = -4.0 * (f - im);
        size_t index = 1;
        while (im != 0) {
            int rem = im % -4;
            im /= -4;
            if (rem < 0) {
                rem = 4 + rem;
                im++;
            }
            if (index < ss.str().length()) {
                ss.str()[index] = (char)(rem + 48);
            } else {
                ss << 0 << rem;
            }
            index += 2;
        }
        fi = (int)f;
    }

    auto r = ss.str();
    std::reverse(r.begin(), r.end());
    ss.str("");
    ss.clear();
    ss << r;
    if (fi != -1) ss << '.' << fi;
    r = ss.str();
    r.erase(r.begin(), std::find_if(r.begin(), r.end(), [](char c) { return c != '0'; }));
    if (r[0] == '.')r = "0" + r;
    return QuaterImaginary(r);
}

int main() {
    using namespace std;

    for (int i = 1; i <= 16; i++) {
        complex<double> c1(i, 0);
        QuaterImaginary qi = toQuaterImaginary(c1);
        complex<double> c2 = qi.toComplex();
        cout << setw(8) << c1 << " -> " << setw(8) << qi << " -> " << setw(8) << c2 << "     ";
        c1 = -c1;
        qi = toQuaterImaginary(c1);
        c2 = qi.toComplex();
        cout << setw(8) << c1 << " -> " << setw(8) << qi << " -> " << setw(8) << c2 << endl;
    }
    cout << endl;

    for (int i = 1; i <= 16; i++) {
        complex<double> c1(0, i);
        QuaterImaginary qi = toQuaterImaginary(c1);
        complex<double> c2 = qi.toComplex();
        cout << setw(8) << c1 << " -> " << setw(8) << qi << " -> " << setw(8) << c2 << "     ";
        c1 = -c1;
        qi = toQuaterImaginary(c1);
        c2 = qi.toComplex();
        cout << setw(8) << c1 << " -> " << setw(8) << qi << " -> " << setw(8) << c2 << endl;
    }

    return 0;
}
