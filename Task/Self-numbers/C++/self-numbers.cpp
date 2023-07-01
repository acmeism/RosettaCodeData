#include <array>
#include <iomanip>
#include <iostream>

const int MC = 103 * 1000 * 10000 + 11 * 9 + 1;
std::array<bool, MC + 1> SV;

void sieve() {
    std::array<int, 10000> dS;
    for (int a = 9, i = 9999; a >= 0; a--) {
        for (int b = 9; b >= 0; b--) {
            for (int c = 9, s = a + b; c >= 0; c--) {
                for (int d = 9, t = s + c; d >= 0; d--) {
                    dS[i--] = t + d;
                }
            }
        }
    }
    for (int a = 0, n = 0; a < 103; a++) {
        for (int b = 0, d = dS[a]; b < 1000; b++, n += 10000) {
            for (int c = 0, s = d + dS[b] + n; c < 10000; c++) {
                SV[dS[c] + s++] = true;
            }
        }
    }
}

int main() {
    sieve();

    std::cout << "The first 50 self numbers are:\n";
    for (int i = 0, count = 0; count <= 50; i++) {
        if (!SV[i]) {
            count++;
            if (count <= 50) {
                std::cout << i << ' ';
            } else {
                std::cout << "\n\n       Index     Self number\n";
            }
        }
    }
    for (int i = 0, limit = 1, count = 0; i < MC; i++) {
        if (!SV[i]) {
            if (++count == limit) {
                //System.out.printf("%,12d   %,13d%n", count, i);
                std::cout << std::setw(12) << count << "   " << std::setw(13) << i << '\n';
                limit *= 10;
            }
        }
    }

    return 0;
}
