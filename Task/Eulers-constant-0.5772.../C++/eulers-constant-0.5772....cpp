#include <array>
#include <cmath>
#include <iomanip>
#include <iostream>

double ByVaccaSeries(int numTerms)
{
    // this method is simple but converges slowly
    // calculate gamma by:
    // 1 * (1/2 - 1/3) +
    // 2 * (1/4 - 1/5 + 1/6 - 1/7) +
    // 3 * (1/8 - 1/9 + 1/10 - 1/11 + 1/12 - 1/13 + 1/14 - 1/15) +
    // 4 * ( . . . ) +
    // . . .
    double gamma = 0;
    size_t next = 4;

    for(double numerator = 1; numerator < numTerms; ++numerator)
    {
        double delta = 0;
        for(size_t denominator = next/2; denominator < next; denominator+=2)
        {
            // calculate terms two at a time
            delta += 1.0/denominator - 1.0/(denominator + 1);
        }

        gamma += numerator * delta;
        next *= 2;
    }
    return gamma;
}

// based on the C entry
double ByEulersMethod()
{
    //Bernoulli numbers with even indices
    const std::array<double, 8> B2 {1.0, 1.0/6, -1.0/30, 1.0/42, -1.0/30,
        5.0/66, -691.0/2730, 7.0/6};

    const int n = 10;

    //n-th harmonic number
    const double h = [] // immediately invoked lambda
    {
        double sum = 1;
        for (int k = 2; k <= n; k++) { sum += 1.0 / k; }
        return sum - log(n);
    }();

    //expansion C = -digamma(1)
    double a = -1.0 / (2*n);
    double r = 1;
    for (int k = 1; k < ssize(B2); k++)
    {
        r *= n * n;
        a += B2[k] / (2*k * r);
    }

    return h + a;
}


int main()
{
    std::cout << std::setprecision(16) << "Vacca series:  " << ByVaccaSeries(32);
    std::cout << std::setprecision(16) << "\nEulers method: " << ByEulersMethod();
}
