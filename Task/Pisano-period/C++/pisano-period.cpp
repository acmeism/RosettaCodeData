#include <functional>
#include <iostream>
#include <iomanip>
#include <numeric>
#include <vector>
using namespace std;

template<typename T>
pair<unsigned, unsigned> floyd(function<T(T)> f, T x0) {
    // Floyd's cycle detection algorithm.
    auto tortoise = f(x0);
    auto hare = f(f(x0));
    while (tortoise != hare) {
        tortoise = f(tortoise);
        hare = f(f(hare));
    }

    // Find the position μ of first repetition.
    unsigned mu = 0;
    tortoise = x0;
    while (tortoise != hare) {
        tortoise = f(tortoise);
        hare = f(hare);
        mu += 1;
    }

    // Find the length of the shortest cycle starting from x_μ
    unsigned lam = 1;
    hare = f(tortoise);
    while (tortoise != hare) {
        hare = f(hare);
        lam += 1;
    }

    return make_pair(lam, mu);
}

unsigned pisano_period(unsigned p) {
    if (p < 2) return 1;
    function<pair<unsigned, unsigned>(pair<unsigned, unsigned>)> f = [&](auto xy) {
        return make_pair(xy.second, (xy.first + xy.second) % p);
    };
    return floyd(f, make_pair(0u, 1u)).first;
}


bool is_prime(unsigned p) {
    if (p < 2) return false;
    if (0 == p % 2) return 2 == p;
    if (0 == p % 3) return 3 == p;
    unsigned d = 5;
    while (d * d <= p) {
        if (0 == p % d) return false;
        d += 2;
        if (0 == p % d) return false;
        d += 4;
    }
    return true;
}

vector<pair<unsigned, unsigned>> factor(unsigned n) {
    vector<pair<unsigned, unsigned>> ans;
    if (n < 2) return ans;
    auto work = [&](unsigned p) {
        if (0 == n % p) {
            unsigned k = 1;
            n /= p;
            while (0 == n % p) {
                k += 1;
                n /= p;
            }
            ans.emplace_back(p, k);
        }
    };
    work(2);
    work(3);
    unsigned d = 5;
    while (d <= n) {
        work(d);
        d += 2;
        work(d);
        d += 4;
    }
    return ans;
}

long long ipow(long long p, unsigned k) {
    long long ans = 1;
    while (0 != k) {
        if (0 != k % 2) ans *= p;
        k /= 2;
        p *= p;
    }
    return ans;
}

unsigned pisano_prime(unsigned p, unsigned k) {
    if (!is_prime(p) || k == 0) {
        return 0;
    }
    return ipow(p, k - 1) * pisano_period(p);
}
unsigned pisano(unsigned n) {
    auto prime_powers{factor(n)};
    unsigned ans = 1;
    for (auto [p, k]: prime_powers) {
        if (1 < ans) {
            ans = lcm(ans, pisano_prime(p, k));
        } else {
            ans = pisano_prime(p, k);
        }
    }
    return ans;
}
int main() {
    for (unsigned p = 2; p < 15; ++p) {
        auto pp = pisano_prime(p, 2);
        if (0 < pp) {
            cout << "pisanoPrime(" << setw(2) << p << ": 2) = " << pp << endl;
        }
    }
    cout << endl;
    for (unsigned p = 2; p < 180; ++p) {
        auto pp = pisano_prime(p, 1);
        if (0 < pp) {
            cout << "pisanoPrime(" << setw(3) << p << ": 1) = " << pp << endl;
        }
    }
    cout << endl;
    cout << "pisano(n) for integers 'n' from 1 to 180 are:" << endl;
    for (unsigned n = 1; n <= 180; ++n) {
        cout << setw(3) << pisano(n) << " ";
        if (0 == n % 15) {
            cout << endl;
        }
    }
    return 0;
}
