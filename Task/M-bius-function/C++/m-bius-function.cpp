#include <iomanip>
#include <iostream>
#include <vector>

constexpr int MU_MAX = 1'000'000;
std::vector<int> MU;

int mobiusFunction(int n) {
    if (!MU.empty()) {
        return MU[n];
    }

    // Populate array
    MU.resize(MU_MAX + 1, 1);
    int root = sqrt(MU_MAX);

    for (int i = 2; i <= root; i++) {
        if (MU[i] == 1) {
            // for each factor found, swap + and -
            for (int j = i; j <= MU_MAX; j += i) {
                MU[j] *= -i;
            }
            // square factor = 0
            for (int j = i * i; j <= MU_MAX; j += i * i) {
                MU[j] = 0;
            }
        }
    }

    for (int i = 2; i <= MU_MAX; i++) {
        if (MU[i] == i) {
            MU[i] = 1;
        } else if (MU[i] == -i) {
            MU[i] = -1;
        } else if (MU[i] < 0) {
            MU[i] = 1;
        } else if (MU[i] > 0) {
            MU[i] = -1;
        }
    }

    return MU[n];
}

int main() {
    std::cout << "First 199 terms of the möbius function are as follows:\n    ";
    for (int n = 1; n < 200; n++) {
        std::cout << std::setw(2) << mobiusFunction(n) << "  ";
        if ((n + 1) % 20 == 0) {
            std::cout << '\n';
        }
    }

    return 0;
}
