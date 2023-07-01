#include <algorithm>
#include <iostream>
#include <ostream>
#include <vector>

/////////////////////////////////////////////////////////////////////////////
// The following is taken from https://cpplove.blogspot.com/2012/07/printing-tuples.html

// Define a type which holds an unsigned integer value
template<std::size_t> struct int_ {};

template <class Tuple, size_t Pos>
std::ostream& print_tuple(std::ostream& out, const Tuple& t, int_<Pos>) {
    out << std::get< std::tuple_size<Tuple>::value - Pos >(t) << ", ";
    return print_tuple(out, t, int_<Pos - 1>());
}

template <class Tuple>
std::ostream& print_tuple(std::ostream& out, const Tuple& t, int_<1>) {
    return out << std::get<std::tuple_size<Tuple>::value - 1>(t);
}

template <class... Args>
std::ostream& operator<<(std::ostream& out, const std::tuple<Args...>& t) {
    out << '(';
    print_tuple(out, t, int_<sizeof...(Args)>());
    return out << ')';
}

/////////////////////////////////////////////////////////////////////////////

template <class RI>
double median(RI beg, RI end) {
    if (beg == end) throw std::runtime_error("Range cannot be empty");
    auto len = end - beg;
    auto m = len / 2;
    if (len % 2 == 1) {
        return *(beg + m);
    }

    return (beg[m - 1] + beg[m]) / 2.0;
}

template <class C>
auto fivenum(C& c) {
    std::sort(c.begin(), c.end());

    auto cbeg = c.cbegin();
    auto cend = c.cend();

    auto len = cend - cbeg;
    auto m = len / 2;
    auto lower = (len % 2 == 1) ? m : m - 1;
    double r2 = median(cbeg, cbeg + lower + 1);
    double r3 = median(cbeg, cend);
    double r4 = median(cbeg + lower + 1, cend);

    return std::make_tuple(*cbeg, r2, r3, r4, *(cend - 1));
}

int main() {
    using namespace std;
    vector<vector<double>> cs = {
        { 15.0, 6.0, 42.0, 41.0, 7.0, 36.0, 49.0, 40.0, 39.0, 47.0, 43.0 },
        { 36.0, 40.0, 7.0, 39.0, 41.0, 15.0 },
        {
            0.14082834,  0.09748790,  1.73131507,  0.87636009, -1.95059594,  0.73438555,
           -0.03035726,  1.46675970, -0.74621349, -0.72588772,  0.63905160,  0.61501527,
           -0.98983780, -1.00447874, -0.62759469,  0.66206163,  1.04312009, -0.10305385,
            0.75775634,  0.32566578
        }
    };

    for (auto & c : cs) {
        cout << fivenum(c) << endl;
    }

    return 0;
}
