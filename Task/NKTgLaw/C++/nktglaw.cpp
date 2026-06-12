#include <iostream>
#include <string>

struct Result {
    double p;
    double NKTg1;
    double NKTg2;
    std::string Tendency1;
    std::string Tendency2;
};

Result nktg(double x, double v, double m, double dm_dt) {
    double p = m * v;
    double nktg1 = x * p;
    double nktg2 = dm_dt * p;

    std::string tendency1;
    if (nktg1 > 0)
        tendency1 = "Moving away from stable state";
    else if (nktg1 < 0)
        tendency1 = "Moving toward stable state";
    else
        tendency1 = "Stable equilibrium";

    std::string tendency2;
    if (nktg2 > 0)
        tendency2 = "Mass variation supports movement";
    else if (nktg2 < 0)
        tendency2 = "Mass variation resists movement";
    else
        tendency2 = "No mass variation effect";

    return {p, nktg1, nktg2, tendency1, tendency2};
}

int main() {
    Result result = nktg(2, 3, 4, -0.5);

    std::cout << "p: " << result.p << std::endl;
    std::cout << "NKTg1: " << result.NKTg1 << std::endl;
    std::cout << "NKTg2: " << result.NKTg2 << std::endl;
    std::cout << "Tendency1: " << result.Tendency1 << std::endl;
    std::cout << "Tendency2: " << result.Tendency2 << std::endl;

    return 0;
}
