#include <iostream>
#include <cstdint>

struct Date {
    std::uint16_t year;
    std::uint8_t month;
    std::uint8_t day;
};

constexpr bool leap(int year)  {
    return year%4==0 && (year%100!=0 || year%400==0);
}

const std::string& weekday(const Date& date) {
    static const std::uint8_t leapdoom[] = {4,1,7,2,4,6,4,1,5,3,7,5};
    static const std::uint8_t normdoom[] = {3,7,7,4,2,6,4,1,5,3,7,5};

    static const std::string days[] = {
        "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday",
        "Friday", "Saturday"
    };

    unsigned const c = date.year/100, r = date.year%100;
    unsigned const s = r/12, t = r%12;

    unsigned const c_anchor = (5 * (c%4) + 2) % 7;
    unsigned const doom = (s + t + t/4 + c_anchor) % 7;
    unsigned const anchor = (leap(date.year) ? leapdoom : normdoom)[date.month-1];
    return days[(doom+date.day-anchor+7)%7];
}

int main(void) {
    const std::string months[] = {"",
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    };

    const Date dates[] = {
        {1800,1,6}, {1875,3,29}, {1915,12,7}, {1970,12,23}, {2043,5,14},
        {2077,2,12}, {2101,4,2}
    };

    for (const Date& d : dates) {
        std::cout << months[d.month] << " " << (int)d.day << ", " << d.year;
        std::cout << (d.year > 2021 ? " will be " : " was ");
        std::cout << "on a " << weekday(d) << std::endl;
    }

    return 0;
}
