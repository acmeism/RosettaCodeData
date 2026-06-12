/*
 * C++ Polynomial Sythetic Division
 * GNU Compile example for filename <synthdiv.cpp>
 * g++ -std=c++11 -o synthdiv synthdiv.cpp
 */

#include <iostream>
#include <vector>
#include <string>
#include <cmath>

/*
 * frmtPolynomial method
 * Returns string for formatted
 * polynomial from int vector of coefs.
 * String looks like ax^2 + bx + c,
 * a, b, and c being the integer
 * coefs in the vector.
 */

std::string frmtPolynomial(std::vector<int> polynomial, bool remainder = false)
{
	std::string r = "";

	if (remainder)
	{
		r = " r: " + std::to_string(polynomial.back());
		polynomial.pop_back();
	}

	std::string formatted = "";
	
	int degree = polynomial.size() - 1;
	int d = degree;

	for (int i : polynomial)
	{
		if (d < degree)
		{
			if (i >= 0)
			{
				formatted += " + ";
			}
			else
			{
				formatted += " - ";
			}
		}

		formatted += std::to_string(abs(i));

		if (d > 1)
		{
			formatted += "x^" + std::to_string(d);
		}
		else if (d == 1)
		{
			formatted += "x";
		}

		d--;
	}

	return formatted;
}

/*
 * syntheticDiv Method
 * Performs Integer Polynomial Sythetic Division
 * on polynomials expressed as vectors of coefs.
 * Takes int vector param for dividend and
 * divisor, and returns int vector quotient.
 */

std::vector<int> syntheticDiv(std::vector<int> dividend, std::vector<int> divisor)
{
	std::vector<int> quotient;
	quotient = dividend;

	int normalizer = divisor[0];
	
	for (int i = 0; i < dividend.size() - (divisor.size() - 1); i++)
	{
		quotient[i] /= normalizer;
		int coef = quotient[i];

		if (coef != 0)
		{
			for (int j = 1; j < divisor.size(); j++)
			{
				quotient[i + j] += -divisor[j] * coef;
			}
        }

	}

	return quotient;
}

/*
 * Example of using the syntheticDiv method
 * and the frmtPolynomial method.
 * Assigns dividend and divisor polynomials:
 * dividend: 1x^3 - 12x^2 + 0x - 42
 * divisor: 1x - 3
 * Outputs both to cout using frmtPolynomial.
 * Printed polynomials look like above format.
 * Processes dividend and divisor in the
 * syntheticDiv method, returns quotient.
 * Outputs quotient to cout using frmtPolynomial again.
 * quotient: 1x^2 - 9x - 27 r: -123
 */

int main(int argc, char **argv)
{
	std::vector<int> dividend{ 1, -12, 0, -42};
	std::vector<int> divisor{ 1, -3};

	std::cout << frmtPolynomial(dividend) << "\n";
	std::cout << frmtPolynomial(divisor) << "\n";

	std::vector<int> quotient = syntheticDiv(dividend, divisor);

	std::cout << frmtPolynomial(quotient, true) << "\n";

}
