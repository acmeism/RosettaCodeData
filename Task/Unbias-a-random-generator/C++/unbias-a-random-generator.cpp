#include <iostream>
#include <random>

std::default_random_engine generator;
bool biased(int n) {
    std::uniform_int_distribution<int> distribution(1, n);
    return distribution(generator) == 1;
}

bool unbiased(int n) {
    bool flip1, flip2;

    /* Flip twice, and check if the values are the same.
     * If so, flip again. Otherwise, return the value of the first flip. */

    do {
        flip1 = biased(n);
        flip2 = biased(n);
    } while (flip1 == flip2);

    return flip1;
}

int main() {
    for (size_t n = 3; n <= 6; n++) {
        int biasedZero = 0;
        int biasedOne = 0;
        int unbiasedZero = 0;
        int unbiasedOne = 0;

        for (size_t i = 0; i < 100000; i++) {
            if (biased(n)) {
                biasedOne++;
            } else {
                biasedZero++;
            }
            if (unbiased(n)) {
                unbiasedOne++;
            } else {
                unbiasedZero++;
            }
        }

        std::cout << "(N = " << n << ")\n";
        std::cout << "Biased:\n";
        std::cout << "   0 = " << biasedZero << "; " << biasedZero / 1000.0 << "%\n";
        std::cout << "   1 = " << biasedOne << "; " << biasedOne / 1000.0 << "%\n";
        std::cout << "Unbiased:\n";
        std::cout << "   0 = " << unbiasedZero << "; " << unbiasedZero / 1000.0 << "%\n";
        std::cout << "   1 = " << unbiasedOne << "; " << unbiasedOne / 1000.0 << "%\n";
        std::cout << '\n';
    }
    return 0;
}
