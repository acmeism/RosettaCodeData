#include <math.h>
#include <numbers>
#include <stdio.h>
#include <vector>

// Calculate the coefficients used by Spouge's approximation (based on the C
// implemetation)
std::vector<double> CalculateCoefficients(int numCoeff)
{
    std::vector<double> c(numCoeff);
    double k1_factrl = 1.0;
    c[0] = sqrt(2.0 * std::numbers::pi);
    for(size_t k=1; k < numCoeff; k++)
    {
        c[k] = exp(numCoeff-k) * pow(numCoeff-k, k-0.5) / k1_factrl;
        k1_factrl *= -(double)k;
    }
    return c;
}

// The Spouge approximation
double Gamma(const std::vector<double>& coeffs, double x)
{
        const size_t numCoeff = coeffs.size();
        double accm = coeffs[0];
        for(size_t k=1; k < numCoeff; k++)
        {
            accm += coeffs[k] / ( x + k );
        }
        accm *= exp(-(x+numCoeff)) * pow(x+numCoeff, x+0.5);
        return accm/x;
}

int main()
{
    // estimate the gamma function with 1, 4, and 10 coefficients
    const auto coeff1 = CalculateCoefficients(1);
    const auto coeff4 = CalculateCoefficients(4);
    const auto coeff10 = CalculateCoefficients(10);

    const auto inputs = std::vector<double>{
        0.001, 0.01, 0.1, 0.5, 1.0,
        1.461632145, // minimum of the gamma function
        2, 2.5, 3, 4, 5, 6, 7, 8, 9, 10, 50, 100,
        150 // causes overflow for this implemetation
        };

    printf("%16s%16s%16s%16s%16s\n", "gamma( x ) =", "Spouge 1", "Spouge 4", "Spouge 10", "built-in");
    for(auto x : inputs)
    {
        printf("gamma(%7.3f) = %16.10g %16.10g %16.10g %16.10g\n",
            x,
            Gamma(coeff1, x),
            Gamma(coeff4, x),
            Gamma(coeff10, x),
            std::tgamma(x)); // built-in gamma function
    }
}
