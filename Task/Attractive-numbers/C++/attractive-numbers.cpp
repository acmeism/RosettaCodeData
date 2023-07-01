#include <iostream>
#include <iomanip>

#define MAX 120

using namespace std;

bool is_prime(int n) {
    if (n < 2) return false;
    if (!(n % 2)) return n == 2;
    if (!(n % 3)) return n == 3;
    int d = 5;
    while (d *d <= n) {
        if (!(n % d)) return false;
        d += 2;
        if (!(n % d)) return false;
        d += 4;
    }
    return true;
}

int count_prime_factors(int n) {
    if (n == 1) return 0;
    if (is_prime(n)) return 1;
    int count = 0, f = 2;
    while (true) {
        if (!(n % f)) {
            count++;
            n /= f;
            if (n == 1) return count;
            if (is_prime(n)) f = n;
        }
        else if (f >= 3) f += 2;
        else f = 3;
    }
}

int main() {
    cout << "The attractive numbers up to and including " << MAX << " are:" << endl;
    for (int i = 1, count = 0; i <= MAX; ++i) {
        int n = count_prime_factors(i);
        if (is_prime(n)) {
            cout << setw(4) << i;
            if (!(++count % 20)) cout << endl;
        }
    }
    cout << endl;
    return 0;
}
