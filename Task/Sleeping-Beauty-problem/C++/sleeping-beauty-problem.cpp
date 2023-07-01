#include <iostream>
#include <random>

int main() {
    std::cout.imbue(std::locale(""));
    const int experiments = 1000000;
    std::random_device dev;
    std::default_random_engine engine(dev());
    std::uniform_int_distribution<int> distribution(0, 1);
    int heads = 0, wakenings = 0;
    for (int i = 0; i < experiments; ++i) {
        ++wakenings;
        switch (distribution(engine)) {
        case 0: // heads
            ++heads;
            break;
        case 1: // tails
            ++wakenings;
            break;
        }
    }
    std::cout << "Wakenings over " << experiments
              << " experiments: " << wakenings << '\n';
    std::cout << "Sleeping Beauty should estimate a credence of: "
              << double(heads) / wakenings << '\n';
}
