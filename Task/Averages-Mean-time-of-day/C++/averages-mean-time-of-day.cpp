#include <iomanip>
#include <iostream>
#include <vector>

#define _USE_MATH_DEFINES
#include <math.h>

struct Time {
    int hour, minute, second;

    friend std::ostream &operator<<(std::ostream &, const Time &);
};

std::ostream &operator<<(std::ostream &os, const Time &t) {
    return os << std::setfill('0')
        << std::setw(2) << t.hour << ':'
        << std::setw(2) << t.minute << ':'
        << std::setw(2) << t.second;
}

double timeToDegrees(Time &&t) {
    return 360.0 * t.hour / 24.0
        + 360.0 * t.minute / (24 * 60.0)
        + 360.0 * t.second / (24 * 3600.0);
}

Time degreesToTime(double angle) {
    while (angle < 0.0) {
        angle += 360.0;
    }
    while (angle > 360.0) {
        angle -= 360.0;
    }

    double totalSeconds = 24.0 * 60 * 60 * angle / 360;
    Time t;

    t.second = (int)totalSeconds % 60;
    t.minute = ((int)totalSeconds % 3600 - t.second) / 60;
    t.hour = (int)totalSeconds / 3600;

    return t;
}

double meanAngle(const std::vector<double> &angles) {
    double yPart = 0.0, xPart = 0.0;
    for (auto a : angles) {
        xPart += cos(a * M_PI / 180);
        yPart += sin(a * M_PI / 180);
    }
    return atan2(yPart / angles.size(), xPart / angles.size()) * 180 / M_PI;
}

int main() {
    std::vector<double> tv;
    tv.push_back(timeToDegrees({ 23, 0, 17 }));
    tv.push_back(timeToDegrees({ 23, 40, 20 }));
    tv.push_back(timeToDegrees({ 0, 12, 45 }));
    tv.push_back(timeToDegrees({ 0, 17, 19 }));

    double ma = meanAngle(tv);
    auto mt = degreesToTime(ma);
    std::cout << mt << '\n';

    return 0;
}
