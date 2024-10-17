#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

typedef struct {
    uint16_t year;
    uint8_t month;
    uint8_t day;
} Date;

bool leap(uint16_t year) {
    return year%4==0 && (year%100!=0 || year%400==0);
}

const char *weekday(Date date) {
    static const uint8_t leapdoom[] = {4,1,7,4,2,6,4,1,5,3,7,5};
    static const uint8_t normdoom[] = {3,7,7,4,2,6,4,1,5,3,7,5};
    static const char *days[] = {
        "Sunday", "Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday"
    };

    unsigned c = date.year/100, r = date.year%100;
    unsigned s = r/12, t = r%12;

    unsigned c_anchor = (5 * (c%4) + 2) % 7;
    unsigned doom = (s + t + (t/4) + c_anchor) % 7;
    unsigned anchor = (leap(date.year) ? leapdoom : normdoom)[date.month-1];
    return days[(doom+date.day-anchor+7)%7];
}

int main(void) {
    const char *past = "was", *future = "will be";
    const char *months[] = { "",
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    };

    const Date dates[] = {
        {1800,1,6}, {1875,3,29}, {1915,12,7}, {1970,12,23}, {2043,5,14},
        {2077,2,12}, {2101,4,2}
    };

    int i;
    for (i=0; i < sizeof(dates)/sizeof(Date); i++) {
        printf("%s %d, %d %s on a %s.\n",
            months[dates[i].month], dates[i].day, dates[i].year,
            dates[i].year > 2021 ? future : past,
            weekday(dates[i]));
    }

    return 0;
}
