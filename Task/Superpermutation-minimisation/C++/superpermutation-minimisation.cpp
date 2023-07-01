#include <array>
#include <iostream>
#include <vector>

constexpr int MAX = 12;

static std::vector<char> sp;
static std::array<int, MAX> count;
static int pos = 0;

int factSum(int n) {
    int s = 0;
    int x = 0;
    int f = 1;
    while (x < n) {
        f *= ++x;
        s += f;
    }
    return s;
}

bool r(int n) {
    if (n == 0) {
        return false;
    }
    char c = sp[pos - n];
    if (--count[n] == 0) {
        count[n] = n;
        if (!r(n - 1)) {
            return false;
        }
    }
    sp[pos++] = c;
    return true;
}

void superPerm(int n) {
    pos = n;
    int len = factSum(n);
    if (len > 0) {
        sp.resize(len);
    }
    for (size_t i = 0; i <= n; i++) {
        count[i] = i;
    }
    for (size_t i = 1; i <= n; i++) {
        sp[i - 1] = '0' + i;
    }
    while (r(n)) {}
}

int main() {
    for (size_t n = 0; n < MAX; n++) {
        superPerm(n);
        std::cout << "superPerm(" << n << ") len = " << sp.size() << '\n';
    }

    return 0;
}
