#include <array>
#include <iomanip>
#include <iostream>
#include <vector>

int indexOf(const std::vector<int> &haystack, int needle) {
    auto it = haystack.cbegin();
    auto end = haystack.cend();
    int idx = 0;
    for (; it != end; it = std::next(it)) {
        if (*it == needle) {
            return idx;
        }
        idx++;
    }
    return -1;
}

bool getDigits(int n, int le, std::vector<int> &digits) {
    while (n > 0) {
        auto r = n % 10;
        if (r == 0 || indexOf(digits, r) >= 0) {
            return false;
        }
        le--;
        digits[le] = r;
        n /= 10;
    }
    return true;
}

int removeDigit(const std::vector<int> &digits, int le, int idx) {
    static std::array<int, 5> pows = { 1, 10, 100, 1000, 10000 };

    int sum = 0;
    auto pow = pows[le - 2];
    for (int i = 0; i < le; i++) {
        if (i == idx) continue;
        sum += digits[i] * pow;
        pow /= 10;
    }
    return sum;
}

int main() {
    std::vector<std::pair<int, int>> lims = { {12, 97}, {123, 986}, {1234, 9875}, {12345, 98764} };
    std::array<int, 5> count;
    std::array<std::array<int, 10>, 5> omitted;

    std::fill(count.begin(), count.end(), 0);
    std::for_each(omitted.begin(), omitted.end(),
        [](auto &a) {
            std::fill(a.begin(), a.end(), 0);
        }
    );

    for (size_t i = 0; i < lims.size(); i++) {
        std::vector<int> nDigits(i + 2);
        std::vector<int> dDigits(i + 2);

        for (int n = lims[i].first; n <= lims[i].second; n++) {
            std::fill(nDigits.begin(), nDigits.end(), 0);
            bool nOk = getDigits(n, i + 2, nDigits);
            if (!nOk) {
                continue;
            }
            for (int d = n + 1; d <= lims[i].second + 1; d++) {
                std::fill(dDigits.begin(), dDigits.end(), 0);
                bool dOk = getDigits(d, i + 2, dDigits);
                if (!dOk) {
                    continue;
                }
                for (size_t nix = 0; nix < nDigits.size(); nix++) {
                    auto digit = nDigits[nix];
                    auto dix = indexOf(dDigits, digit);
                    if (dix >= 0) {
                        auto rn = removeDigit(nDigits, i + 2, nix);
                        auto rd = removeDigit(dDigits, i + 2, dix);
                        if ((double)n / d == (double)rn / rd) {
                            count[i]++;
                            omitted[i][digit]++;
                            if (count[i] <= 12) {
                                std::cout << n << '/' << d << " = " << rn << '/' << rd << " by omitting " << digit << "'s\n";
                            }
                        }
                    }
                }
            }
        }

        std::cout << '\n';
    }

    for (int i = 2; i <= 5; i++) {
        std::cout << "There are " << count[i - 2] << ' ' << i << "-digit fractions of which:\n";
        for (int j = 1; j <= 9; j++) {
            if (omitted[i - 2][j] == 0) {
                continue;
            }
            std::cout << std::setw(6) << omitted[i - 2][j] << " have " << j << "'s omitted\n";
        }
        std::cout << '\n';
    }

    return 0;
}
