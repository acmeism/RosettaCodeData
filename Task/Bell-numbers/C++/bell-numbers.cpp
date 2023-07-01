#include <iostream>
#include <vector>

#ifdef HAVE_BOOST
#include <boost/multiprecision/cpp_int.hpp>
typedef boost::multiprecision::cpp_int integer;
#else
typedef unsigned int integer;
#endif

auto make_bell_triangle(int n) {
    std::vector<std::vector<integer>> bell(n);
    for (int i = 0; i < n; ++i)
        bell[i].assign(i + 1, 0);
    bell[0][0] = 1;
    for (int i = 1; i < n; ++i) {
        std::vector<integer>& row = bell[i];
        std::vector<integer>& prev_row = bell[i - 1];
        row[0] = prev_row[i - 1];
        for (int j = 1; j <= i; ++j)
            row[j] = row[j - 1] + prev_row[j - 1];
    }
    return bell;
}

int main() {
#ifdef HAVE_BOOST
    const int size = 50;
#else
    const int size = 15;
#endif
    auto bell(make_bell_triangle(size));

    const int limit = 15;
    std::cout << "First " << limit << " Bell numbers:\n";
    for (int i = 0; i < limit; ++i)
        std::cout << bell[i][0] << '\n';

#ifdef HAVE_BOOST
    std::cout << "\n50th Bell number is " << bell[49][0] << "\n\n";
#endif

    std::cout << "First 10 rows of the Bell triangle:\n";
    for (int i = 0; i < 10; ++i) {
        std::cout << bell[i][0];
        for (int j = 1; j <= i; ++j)
            std::cout << ' ' << bell[i][j];
        std::cout << '\n';
    }
    return 0;
}
