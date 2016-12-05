#include <cstdlib>
#include <iostream>
#include <sstream>
#include <iomanip>
#include <list>

bool k_prime(unsigned n, unsigned k) {
    unsigned f = 0;
    for (unsigned p = 2; f < k && p * p <= n; p++)
        while (0 == n % p) { n /= p; f++; }
    return f + (n > 1 ? 1 : 0) == k;
}

std::list<unsigned> primes(unsigned k, unsigned n)  {
    std::list<unsigned> list;
    for (unsigned i = 2;list.size() < n;i++)
        if (k_prime(i, k)) list.push_back(i);
    return list;
}

int main(const int argc, const char* argv[]) {
    using namespace std;
    for (unsigned k = 1; k <= 5; k++) {
        ostringstream os("");
        const list<unsigned> l = primes(k, 10);
        for (list<unsigned>::const_iterator i = l.begin(); i != l.end(); i++)
            os << setw(4) << *i;
        cout << "k = " << k << ':' << os.str() << endl;
    }

	return EXIT_SUCCESS;
}
