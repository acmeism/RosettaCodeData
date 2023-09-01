#include <iostream>
#include <string>
#include <boost/date_time/gregorian/gregorian.hpp>

bool is_palindrome(const std::string& str) {
    for (size_t i = 0, j = str.size(); i + 1 < j; ++i, --j) {
        if (str[i] != str[j - 1])
            return false;
    }
    return true;
}

int main() {
    using boost::gregorian::date;
    using boost::gregorian::day_clock;
    using boost::gregorian::date_duration;

    date today(day_clock::local_day());
    date_duration day(1);
    int count = 15;
    std::cout << "Next " << count << " palindrome dates:\n";
    for (; count > 0; today += day) {
        if (is_palindrome(to_iso_string(today))) {
            std::cout << to_iso_extended_string(today) << '\n';
            --count;
        }
    }
    return 0;
}
