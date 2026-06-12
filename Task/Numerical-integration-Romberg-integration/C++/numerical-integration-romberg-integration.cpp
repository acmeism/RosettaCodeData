#include <cmath>
#include <functional>
#include <iomanip>
#include <iostream>
#include <stdexcept>
#include <vector>

std::pair<double, int> rombergIntegration(
    const std::function<double(double)>& func,
    double a,
    double b,
    int maxDepth,
    double tol = 1e-8
) {
    if (maxDepth < 1)
        throw std::invalid_argument("maxDepth must be at least 1");
    if (a == b)
        return {0.0, 0};
    if (a > b)
        std::swap(a, b);

    std::vector<std::vector<double>> R(maxDepth+1, std::vector<double>(maxDepth+1, 0.0));

    R[0][0] = 0.5 * (b - a) * (func(a) + func(b));
    double h = b - a;

    for (int i = 1; i <= maxDepth; ++i) {
        h /= 2.0;
        double sum = 0.0;
        int numNewPoints = 1 << (i - 1);
        for (int k = 1; k <= numNewPoints; ++k) {
            double x = a + (2 * k - 1) * h;
            sum += func(x);
        }
        R[i][0] = 0.5 * R[i-1][0] + sum * h;

        for (int j = 1; j <= i; ++j) {
            double factor = std::pow(4.0, j);
            R[i][j] = (factor * R[i][j-1] - R[i-1][j-1]) / (factor - 1.0);
        }

        if (std::abs(R[i][i] - R[i-1][i-1]) < tol)
            return {R[i][i], i};
    }

    return {R[maxDepth][maxDepth], maxDepth};
}

int main() {
    auto [result1, depth1] = rombergIntegration(
        [](double x) { return std::sin(x); },
        0.0,
        1.0,
        10,
        1e-9
    );

    std::cout << "Integral = " << std::fixed << std::setprecision(8) << result1
              << " (converged at depth " << depth1 << ")\n";

    auto [result2, depth2] = rombergIntegration(
		[](double x) { return std::exp(x); },
		-3.0,
		3.0,
		10,
		1e-8
	);
    std::cout << "Integral = " << std::fixed << std::setprecision(7) << result2
              << " (converged at depth " << depth2 << ")\n";
    return 0;
}
