#include <iostream>
#include <numeric>
#include <vector>
#include <execution>

using namespace std;

int mulInv(int a, int b) {
	int b0 = b;
	int x0 = 0;
	int x1 = 1;

	if (b == 1) {
		return 1;
	}

	while (a > 1) {
		int q = a / b;
		int amb = a % b;
		a = b;
		b = amb;

		int xqx = x1 - q * x0;
		x1 = x0;
		x0 = xqx;
	}

	if (x1 < 0) {
		x1 += b0;
	}

	return x1;
}

int chineseRemainder(vector<int> n, vector<int> a) {
	int prod = std::reduce(std::execution::seq, n.begin(), n.end(), 1, [](int a, int b) { return a * b; });

	int sm = 0;
	for (int i = 0; i < n.size(); i++) {
		int p = prod / n[i];
		sm += a[i] * mulInv(p, n[i])*p;
	}

	return sm % prod;
}

int main() {
	vector<int> n = { 3, 5, 7 };
	vector<int> a = { 2, 3, 2 };

	cout << chineseRemainder(n,a) << endl;

	return 0;
}
