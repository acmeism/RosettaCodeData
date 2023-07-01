#include <iostream>
#include <vector>

__int128 imax(__int128 a, __int128 b) {
    if (a > b) {
        return a;
    }
    return b;
}

__int128 ipow(__int128 b, __int128 n) {
    if (n == 0) {
        return 1;
    }
    if (n == 1) {
        return b;
    }

    __int128 res = b;
    while (n > 1) {
        res *= b;
        n--;
    }
    return res;
}

__int128 imod(__int128 m, __int128 n) {
    __int128 result = m % n;
    if (result < 0) {
        result += n;
    }
    return result;
}

bool valid(__int128 n) {
    if (n < 0) {
        return false;
    }
    while (n > 0) {
        int r = n % 10;
        if (r > 1) {
            return false;
        }
        n /= 10;
    }
    return true;
}

__int128 mpm(const __int128 n) {
    if (n == 1) {
        return 1;
    }

    std::vector<__int128> L(n * n, 0);
    L[0] = 1;
    L[1] = 1;

    __int128 m, k, r, j;
    m = 0;
    while (true) {
        m++;
        if (L[(m - 1) * n + imod(-ipow(10, m), n)] == 1) {
            break;
        }
        L[m * n + 0] = 1;
        for (k = 1; k < n; k++) {
            L[m * n + k] = imax(L[(m - 1) * n + k], L[(m - 1) * n + imod(k - ipow(10, m), n)]);
        }
    }

    r = ipow(10, m);
    k = imod(-r, n);

    for (j = m - 1; j >= 1; j--) {
        if (L[(j - 1) * n + k] == 0) {
            r = r + ipow(10, j);
            k = imod(k - ipow(10, j), n);
        }
    }

    if (k == 1) {
        r++;
    }
    return r / n;
}

std::ostream& operator<<(std::ostream& os, __int128 n) {
    char buffer[64]; // more then is needed, but is nice and round;
    int pos = (sizeof(buffer) / sizeof(char)) - 1;
    bool negative = false;

    if (n < 0) {
        negative = true;
        n = -n;
    }

    buffer[pos] = 0;
    while (n > 0) {
        int rem = n % 10;
        buffer[--pos] = rem + '0';
        n /= 10;
    }
    if (negative) {
        buffer[--pos] = '-';
    }
    return os << &buffer[pos];
}

void test(__int128 n) {
    __int128 mult = mpm(n);
    if (mult > 0) {
        std::cout << n << " * " << mult << " = " << (n * mult) << '\n';
    } else {
        std::cout << n << "(no solution)\n";
    }
}

int main() {
    int i;

    // 1-10 (inclusive)
    for (i = 1; i <= 10; i++) {
        test(i);
    }
    // 95-105 (inclusive)
    for (i = 95; i <= 105; i++) {
        test(i);
    }
    test(297);
    test(576);
    test(594); // needs a larger number type (64 bits signed)
    test(891);
    test(909);
    test(999); // needs a larger number type (87 bits signed)

    // optional
    test(1998);
    test(2079);
    test(2251);
    test(2277);

    // stretch
    test(2439);
    test(2997);
    test(4878);

    return 0;
}
