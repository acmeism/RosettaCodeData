#include <iostream>

bool sameDigits(int n, int b) {
    int f = n % b;
    while ((n /= b) > 0) {
        if (n % b != f) {
            return false;
        }
    }
    return true;
}

bool isBrazilian(int n) {
    if (n < 7) return false;
    if (n % 2 == 0)return true;
    for (int b = 2; b < n - 1; b++) {
        if (sameDigits(n, b)) {
            return true;
        }
    }
    return false;
}

bool isPrime(int n) {
    if (n < 2)return false;
    if (n % 2 == 0)return n == 2;
    if (n % 3 == 0)return n == 3;
    int d = 5;
    while (d * d <= n) {
        if (n % d == 0)return false;
        d += 2;
        if (n % d == 0)return false;
        d += 4;
    }
    return true;
}

int main() {
    for (auto kind : { "", "odd ", "prime " }) {
        bool quiet = false;
        int BigLim = 99999;
        int limit = 20;
        std::cout << "First " << limit << ' ' << kind << "Brazillian numbers:\n";
        int c = 0;
        int n = 7;
        while (c < BigLim) {
            if (isBrazilian(n)) {
                if (!quiet)std::cout << n << ' ';
                if (++c == limit) {
                    std::cout << "\n\n";
                    quiet = true;
                }
            }
            if (quiet && kind != "") continue;
            if (kind == "") {
                n++;
            }
            else if (kind == "odd ") {
                n += 2;
            }
            else if (kind == "prime ") {
                while (true) {
                    n += 2;
                    if (isPrime(n)) break;
                }
            } else {
                throw new std::runtime_error("Unexpected");
            }
        }
        if (kind == "") {
            std::cout << "The " << BigLim + 1 << "th Brazillian number is: " << n << "\n\n";
        }
    }

    return 0;
}
