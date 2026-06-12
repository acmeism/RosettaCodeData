#include <iostream>
#include <iomanip>
#include <string>
#include <cmath>
#include <utility>
#include <vector>

using namespace std;

static const double PI = acos(-1.0);

double affine_remap(const pair<double, double>& from, double x, const pair<double, double>& to)
{
	return to.first + (x - from.first) * (to.second - to.first) / (from.second - from.first);
}

vector<double> cheb_coef(const vector<double>& f_vals)
{
	const int n = f_vals.size();
	const double theta = PI / n;
	vector<double> retval(n, 0.0);
	for (int ii = 0; ii < n; ++ii)
	{
		double f = f_vals[ii] * 2.0 / n;
		const double phi = (ii + 0.5) * theta;
		double c1 = cos(phi), s1 = sin(phi);
		double c = 1.0, s = 0.0;
		for (int j = 0; j < n; j++)
		{
			retval[j] += f * c;
			// update c -> cos(j*phi) for next value of j
			const double cNext = c * c1 - s * s1;
			s = c * s1 + s * c1;
			c = cNext;
		}
	}
	return retval;
}

template<class F_> vector<double> cheb_coef(const F_& func, int n, const pair<double, double>& domain)
{
	auto remap = [&](double x){return affine_remap({ -1.0, 1.0 }, x, domain); };
	const double theta = PI / n;
	vector<double> fVals(n);
	for (int ii = 0; ii < n; ++ii)
		fVals[ii] = func(remap(cos((ii + 0.5) * theta)));
	return cheb_coef(fVals);
}

double cheb_eval(const vector<double>& coef, double x)
{
	double a = 1.0, b = x, c;
	double retval = 0.5 * coef[0] + b * coef[1];
	for (auto pc = coef.begin() + 2; pc != coef.end(); a = b, b = c, ++pc)
	{
		c = 2.0 * b * x - a;
		retval += (*pc) * c;
	}
	return retval;
}
double cheb_eval(const vector<double>& coef, const pair<double, double>& domain, double x)
{
	return cheb_eval(coef, affine_remap(domain, x, { -1.0, 1.0 }));
}

struct ChebyshevApprox_
{
	vector<double> coeffs_;
	pair<double, double> domain_;

	double operator()(double x) const { return cheb_eval(coeffs_, domain_, x); }

	template<class F_> ChebyshevApprox_
		(const F_& func,
		int n,
		const pair<double, double>& domain)
		:
		coeffs_(cheb_coef(func, n, domain)),
		domain_(domain)
	{ }
};


int main(void)
{
	static const int N = 10;
	ChebyshevApprox_ fApprox(cos, N, { 0.0, 1.0 });
	cout << "Coefficients: " << setprecision(14);
	for (const auto& c : fApprox.coeffs_)
		cout << "\t" << c << "\n";

	for (;;)
	{
		cout << "Enter x, or non-numeric value to quit:\n";
		double x;
		if (!(cin >> x))
			return 0;
		cout << "True value: \t" << cos(x) << "\n";
		cout << "Approximate: \t" << fApprox(x) << "\n";
	}
}
