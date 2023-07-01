#include <iostream>
#include <vector>
#include <chrono>
#include <climits>
#include <cmath>

using namespace std;

vector <long long> primes{ 3, 5 };

int main()
{
	cout.imbue(locale(""));
	const int cutOff = 200, bigUn = 100000,
	          chunks = 50, little = bigUn / chunks;
    const char tn[] = " cuban prime";
	cout << "The first " << cutOff << tn << "s:" << endl;
	int c = 0;
	bool showEach = true;
	long long u = 0, v = 1;
	auto st = chrono::system_clock::now();

	for (long long i = 1; i <= LLONG_MAX; i++)
	{
		bool found = false;
		long long mx = (long long)(ceil(sqrt(v += (u += 6))));
		for (long long item : primes)
		{
			if (item > mx) break;
			if (v % item == 0) { found = true; break; }
		}
		if (!found)
		{
			c += 1; if (showEach)
			{
				for (long long z = primes.back() + 2; z <= v - 2; z += 2)
				{
					bool fnd = false;
					for (long long item : primes)
					{
						if (item > mx) break;
						if (z % item == 0) { fnd = true; break; }
					}
					if (!fnd) primes.push_back(z);
				}
				primes.push_back(v); cout.width(11); cout << v;
				if (c % 10 == 0) cout << endl;
				if (c == cutOff)
				{
					showEach = false;
					cout << "\nProgress to the " << bigUn << "th" << tn << ": ";
				}
			}
			if (c % little == 0) { cout << "."; if (c == bigUn) break; }
		}
	}
	cout << "\nThe " << c << "th" << tn << " is " << v;
	chrono::duration<double> elapsed_seconds = chrono::system_clock::now() - st;
	cout << "\nComputation time was " << elapsed_seconds.count() << " seconds" << endl;
	return 0;
}
