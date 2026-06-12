#include <iostream>
#include <math.h>

unsigned long long root(unsigned long long base, unsigned int n) {
	if (base < 2) return base;
	if (n == 0) return 1;

	unsigned int n1 = n - 1;
	unsigned long long n2 = n;
	unsigned long long n3 = n1;
	unsigned long long c = 1;
	auto d = (n3 + base) / n2;
	auto e = (n3 * d + base / pow(d, n1)) / n2;

	while (c != d && c != e) {
		c = d;
		d = e;
		e = (n3*e + base / pow(e, n1)) / n2;
	}

	if (d < e) return d;
	return e;
}

int main() {
	using namespace std;

	cout << "3rd root of 8 = " << root(8, 3) << endl;
	cout << "3rd root of 9 = " << root(9, 3) << endl;

	unsigned long long b = 2e18;
	cout << "2nd root of " << b << " = " << root(b, 2) << endl;

	return 0;
}
