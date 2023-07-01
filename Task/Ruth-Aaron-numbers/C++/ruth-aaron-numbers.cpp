#include <iomanip>
#include <iostream>

int prime_factor_sum(int n) {
    int sum = 0;
    for (; (n & 1) == 0; n >>= 1)
        sum += 2;
    for (int p = 3, sq = 9; sq <= n; p += 2) {
        for (; n % p == 0; n /= p)
            sum += p;
        sq += (p + 1) << 2;
    }
    if (n > 1)
        sum += n;
    return sum;
}

int prime_divisor_sum(int n) {
    int sum = 0;
    if ((n & 1) == 0) {
        sum += 2;
        n >>= 1;
        while ((n & 1) == 0)
            n >>= 1;
    }
    for (int p = 3, sq = 9; sq <= n; p += 2) {
        if (n % p == 0) {
            sum += p;
            n /= p;
            while (n % p == 0)
                n /= p;
        }
        sq += (p + 1) << 2;
    }
    if (n > 1)
        sum += n;
    return sum;
}

int main() {
    const int limit = 30;
    int dsum1 = 0, fsum1 = 0, dsum2 = 0, fsum2 = 0;

    std::cout << "First " << limit << " Ruth-Aaron numbers (factors):\n";
    for (int n = 2, count = 0; count < limit; ++n) {
        fsum2 = prime_factor_sum(n);
        if (fsum1 == fsum2) {
            ++count;
            std::cout << std::setw(5) << n - 1
                      << (count % 10 == 0 ? '\n' : ' ');
        }
        fsum1 = fsum2;
    }

    std::cout << "\nFirst " << limit << " Ruth-Aaron numbers (divisors):\n";
    for (int n = 2, count = 0; count < limit; ++n) {
        dsum2 = prime_divisor_sum(n);
        if (dsum1 == dsum2) {
            ++count;
            std::cout << std::setw(5) << n - 1
                      << (count % 10 == 0 ? '\n' : ' ');
        }
        dsum1 = dsum2;
    }

    dsum1 = 0, fsum1 = 0, dsum2 = 0, fsum2 = 0;
    for (int n = 2;; ++n) {
        int fsum3 = prime_factor_sum(n);
        if (fsum1 == fsum2 && fsum2 == fsum3) {
            std::cout << "\nFirst Ruth-Aaron triple (factors): " << n - 2
                      << '\n';
            break;
        }
        fsum1 = fsum2;
        fsum2 = fsum3;
    }
    for (int n = 2;; ++n) {
        int dsum3 = prime_divisor_sum(n);
        if (dsum1 == dsum2 && dsum2 == dsum3) {
            std::cout << "\nFirst Ruth-Aaron triple (divisors): " << n - 2
                      << '\n';
            break;
        }
        dsum1 = dsum2;
        dsum2 = dsum3;
    }
}
