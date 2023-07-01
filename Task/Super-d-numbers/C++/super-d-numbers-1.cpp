#include <iostream>
#include <sstream>
#include <vector>

uint64_t ipow(uint64_t base, uint64_t exp) {
    uint64_t result = 1;
    while (exp) {
        if (exp & 1) {
            result *= base;
        }
        exp >>= 1;
        base *= base;
    }
    return result;
}

int main() {
    using namespace std;

    vector<string> rd{ "22", "333", "4444", "55555", "666666", "7777777", "88888888", "999999999" };

    for (uint64_t ii = 2; ii < 5; ii++) {
        cout << "First 10 super-" << ii << " numbers:\n";
        int count = 0;

        for (uint64_t j = 3; /* empty */; j++) {
            auto k = ii * ipow(j, ii);
            auto kstr = to_string(k);
            auto needle = rd[(size_t)(ii - 2)];
            auto res = kstr.find(needle);
            if (res != string::npos) {
                count++;
                cout << j << ' ';
                if (count == 10) {
                    cout << "\n\n";
                    break;
                }
            }
        }
    }

    return 0;
}
