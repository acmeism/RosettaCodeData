// Reference:
// https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year

#include <iostream>

inline int p(int year) {
    return (year + (year/4) - (year/100) + (year/400)) % 7;
}

bool is_long_year(int year) {
    return p(year) == 4 || p(year - 1) == 3;
}

void print_long_years(int from, int to) {
    for (int year = from, count = 0; year <= to; ++year) {
        if (is_long_year(year)) {
            if (count > 0)
                std::cout << ((count % 10 == 0) ? '\n' : ' ');
            std::cout << year;
            ++count;
        }
    }
}

int main() {
    std::cout << "Long years between 1800 and 2100:\n";
    print_long_years(1800, 2100);
    std::cout << '\n';
    return 0;
}
