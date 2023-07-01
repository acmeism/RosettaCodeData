#include <exception>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <sstream>
#include <vector>

class Frac {
public:

	Frac() : num(0), denom(1) {}

	Frac(int n, int d) {
		if (d == 0) {
			throw std::runtime_error("d must not be zero");
		}

		int sign_of_d = d < 0 ? -1 : 1;
		int g = std::gcd(n, d);

        num = sign_of_d * n / g;
        denom = sign_of_d * d / g;
	}

	Frac operator-() const {
		return Frac(-num, denom);
	}

	Frac operator+(const Frac& rhs) const {
		return Frac(num*rhs.denom + denom * rhs.num, rhs.denom*denom);
	}

	Frac operator-(const Frac& rhs) const {
		return Frac(num*rhs.denom - denom * rhs.num, rhs.denom*denom);
	}

	Frac operator*(const Frac& rhs) const {
		return Frac(num*rhs.num, denom*rhs.denom);
	}

	Frac operator*(int rhs) const {
		return Frac(num * rhs, denom);
	}

	friend std::ostream& operator<<(std::ostream&, const Frac&);

private:
	int num;
	int denom;
};

std::ostream & operator<<(std::ostream & os, const Frac &f) {
	if (f.num == 0 || f.denom == 1) {
		return os << f.num;
	}

	std::stringstream ss;
	ss << f.num << "/" << f.denom;
	return os << ss.str();
}

Frac bernoulli(int n) {
	if (n < 0) {
		throw std::runtime_error("n may not be negative or zero");
	}

	std::vector<Frac> a;
	for (int m = 0; m <= n; m++) {
		a.push_back(Frac(1, m + 1));
		for (int j = m; j >= 1; j--) {
			a[j - 1] = (a[j - 1] - a[j]) * j;
		}
	}

	// returns 'first' Bernoulli number
	if (n != 1) return a[0];
	return -a[0];
}

int binomial(int n, int k) {
	if (n < 0 || k < 0 || n < k) {
		throw std::runtime_error("parameters are invalid");
	}
	if (n == 0 || k == 0) return 1;

	int num = 1;
	for (int i = k + 1; i <= n; i++) {
		num *= i;
	}

	int denom = 1;
	for (int i = 2; i <= n - k; i++) {
		denom *= i;
	}

	return num / denom;
}

std::vector<Frac> faulhaberTraingle(int p) {
	std::vector<Frac> coeffs(p + 1);

	Frac q{ 1, p + 1 };
	int sign = -1;
	for (int j = 0; j <= p; j++) {
		sign *= -1;
		coeffs[p - j] = q * sign * binomial(p + 1, j) * bernoulli(j);
	}

	return coeffs;
}

int main() {

	for (int i = 0; i < 10; i++) {
		std::vector<Frac> coeffs = faulhaberTraingle(i);
		for (auto frac : coeffs) {
			std::cout << std::right << std::setw(5) << frac << "  ";
		}
		std::cout << std::endl;
	}

	return 0;
}
