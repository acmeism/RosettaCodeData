#include <iostream">
#include <cmath>
#include <vector>
#include <algorithm>
#include <iomanip>
#include <numeric>

using namespace std;

// Returns n in binary right justified with length passed and padded with zeroes
const uint* binary(uint n, uint length);

// Returns the sum of the binary ordered subset of rank r.
// Adapted from Sympy implementation.
uint sum_subset_unrank_bin(const vector<uint>& d, uint r);

vector<uint> factors(uint x);

bool isPrime(uint number);

bool isZum(uint n);

ostream& operator<<(ostream& os, const vector<uint>& zumz) {
    for (uint i = 0; i < zumz.size(); i++) {
        if (i % 10 == 0)
            os << endl;
        os << setw(10) << zumz[i] << ' ';
    }
    return os;
}

int main() {
    cout << "First 220 Zumkeller numbers:" << endl;
    vector<uint> zumz;
    for (uint n = 2; zumz.size() < 220; n++)
        if (isZum(n))
            zumz.push_back(n);
    cout << zumz << endl << endl;

    cout << "First 40 odd Zumkeller numbers:" << endl;
    vector<uint> zumz2;
    for (uint n = 2; zumz2.size() < 40; n++)
        if (n % 2 && isZum(n))
            zumz2.push_back(n);
    cout << zumz2 << endl << endl;

    cout << "First 40 odd Zumkeller numbers not ending in 5:" << endl;
    vector<uint> zumz3;
    for (uint n = 2; zumz3.size() < 40; n++)
        if (n % 2 && (n % 10) !=  5 && isZum(n))
            zumz3.push_back(n);
    cout << zumz3 << endl << endl;

    return 0;
}

// Returns n in binary right justified with length passed and padded with zeroes
const uint* binary(uint n, uint length) {
    uint* bin = new uint[length];	    // array to hold result
    fill(bin, bin + length, 0);         // fill with zeroes
    // convert n to binary and store right justified in bin
    for (uint i = 0; n > 0; i++) {
        uint rem = n % 2;
        n /= 2;
        if (rem)
            bin[length - 1 - i] = 1;
    }

    return bin;
}

// Returns the sum of the binary ordered subset of rank r.
// Adapted from Sympy implementation.
uint sum_subset_unrank_bin(const vector<uint>& d, uint r) {
    vector<uint> subset;
    // convert r to binary array of same size as d
    const uint* bits = binary(r, d.size() - 1);

    // get binary ordered subset
    for (uint i = 0; i < d.size() - 1; i++)
        if (bits[i])
            subset.push_back(d[i]);

    delete[] bits;

    return accumulate(subset.begin(), subset.end(), 0u);
}

vector<uint> factors(uint x) {
    vector<uint> result;
    // this will loop from 1 to int(sqrt(x))
    for (uint i = 1; i * i <= x; i++) {
        // Check if i divides x without leaving a remainder
        if (x % i == 0) {
            result.push_back(i);

            if (x / i != i)
                result.push_back(x / i);
        }
    }

    // return the sorted factors of x
    sort(result.begin(), result.end());
    return result;
}

bool isPrime(uint number) {
    if (number < 2) return false;
    if (number == 2) return true;
    if (number % 2 == 0) return false;
    for (uint i = 3; i * i <= number; i += 2)
        if (number % i == 0) return false;

    return true;
}

bool isZum(uint n) {
    // if prime it ain't no zum
    if (isPrime(n))
        return false;

    // get sum of divisors
    const auto d = factors(n);
    uint s = accumulate(d.begin(), d.end(), 0u);

    // if sum is odd or sum < 2*n it ain't no zum
    if (s % 2 || s < 2 * n)
        return false;

    // if we get here and n is odd or n has at least 24 divisors it's a zum!
    // Valid for even n < 99504. To test n beyond this bound, comment out this condition.
    // And wait all day. Thanks to User:Horsth for taking the time to find this bound!
    if (n % 2 || d.size() >= 24)
        return true;

    if (!(s % 2) && d[d.size() - 1] <= s / 2)
        for (uint x = 2; (uint) log2(x) < (d.size() - 1); x++) // using log2 prevents overflow
            if (sum_subset_unrank_bin(d, x) == s / 2)
                return true; // congratulations it's a zum num!!

    // if we get here it ain't no zum
    return false;
}
