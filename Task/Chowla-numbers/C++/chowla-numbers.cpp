#include <vector>
#include <iostream>

using namespace std;

int chowla(int n)
{
	int sum = 0;
	for (int i = 2, j; i * i <= n; i++)
		if (n % i == 0) sum += i + (i == (j = n / i) ? 0 : j);
	return sum;
}

vector<bool> sieve(int limit)
{
	// True denotes composite, false denotes prime.
	// Only interested in odd numbers >= 3
	vector<bool> c(limit);
	for (int i = 3; i * 3 < limit; i += 2)
		if (!c[i] && (chowla(i) == 0))
			for (int j = 3 * i; j < limit; j += 2 * i)
				c[j] = true;
	return c;
}

int main()
{
	cout.imbue(locale(""));
	for (int i = 1; i <= 37; i++)
		cout << "chowla(" << i << ") = " << chowla(i) << "\n";
	int count = 1, limit = (int)(1e7), power = 100;
	vector<bool> c = sieve(limit);
	for (int i = 3; i < limit; i += 2)
	{
		if (!c[i]) count++;
		if (i == power - 1)
		{
			cout << "Count of primes up to " << power << " = "<< count <<"\n";
			power *= 10;
		}
	}

	count = 0; limit = 35000000;
	int k = 2, kk = 3, p;
	for (int i = 2; ; i++)
	{
		if ((p = k * kk) > limit) break;
		if (chowla(p) == p - 1)
		{
			cout << p << " is a number that is perfect\n";
			count++;
		}
		k = kk + 1; kk += k;
	}
	cout << "There are " << count << " perfect numbers <= 35,000,000\n";
	return 0;
}
