#include <algorithm>
#include <iostream>
#include <numeric>
#include <vector>

void polyRegression(const std::vector<int>& x, const std::vector<int>& y) {
    int n = x.size();
    std::vector<int> r(n);
    std::iota(r.begin(), r.end(), 0);
    double xm = std::accumulate(x.begin(), x.end(), 0.0) / x.size();
    double ym = std::accumulate(y.begin(), y.end(), 0.0) / y.size();
    double x2m = std::transform_reduce(r.begin(), r.end(), 0.0, std::plus<double>{}, [](double a) {return a * a; }) / r.size();
    double x3m = std::transform_reduce(r.begin(), r.end(), 0.0, std::plus<double>{}, [](double a) {return a * a * a; }) / r.size();
    double x4m = std::transform_reduce(r.begin(), r.end(), 0.0, std::plus<double>{}, [](double a) {return a * a * a * a; }) / r.size();

    double xym = std::transform_reduce(x.begin(), x.end(), y.begin(), 0.0, std::plus<double>{}, std::multiplies<double>{});
    xym /= fmin(x.size(), y.size());

    double x2ym = std::transform_reduce(x.begin(), x.end(), y.begin(), 0.0, std::plus<double>{}, [](double a, double b) { return a * a * b; });
    x2ym /= fmin(x.size(), y.size());

    double sxx = x2m - xm * xm;
    double sxy = xym - xm * ym;
    double sxx2 = x3m - xm * x2m;
    double sx2x2 = x4m - x2m * x2m;
    double sx2y = x2ym - x2m * ym;

    double b = (sxy * sx2x2 - sx2y * sxx2) / (sxx * sx2x2 - sxx2 * sxx2);
    double c = (sx2y * sxx - sxy * sxx2) / (sxx * sx2x2 - sxx2 * sxx2);
    double a = ym - b * xm - c * x2m;

    auto abc = [a, b, c](int xx) {
        return a + b * xx + c * xx*xx;
    };

    std::cout << "y = " << a << " + " << b << "x + " << c << "x^2" << std::endl;
    std::cout << " Input  Approximation" << std::endl;
    std::cout << " x   y     y1" << std::endl;

    auto xit = x.cbegin();
    auto xend = x.cend();
    auto yit = y.cbegin();
    auto yend = y.cend();
    while (xit != xend && yit != yend) {
        printf("%2d %3d  %5.1f\n", *xit, *yit, abc(*xit));
        xit = std::next(xit);
        yit = std::next(yit);
    }
}

int main() {
    using namespace std;

    vector<int> x(11);
    iota(x.begin(), x.end(), 0);

    vector<int> y{ 1, 6, 17, 34, 57, 86, 121, 162, 209, 262, 321 };

    polyRegression(x, y);

    return 0;
}
