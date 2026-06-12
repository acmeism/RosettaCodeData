#include <iostream>
#include <random>
#include <vector>

double equalBirthdays(int nSharers, int groupSize, int nRepetitions) {
    std::default_random_engine generator;
    std::uniform_int_distribution<int> distribution(0, 364);
    std::vector<int> group(365);

    int eq = 0;
    for (int i = 0; i < nRepetitions; i++) {
        std::fill(group.begin(), group.end(), 0);
        for (int j = 0; j < groupSize; j++) {
            int day = distribution(generator);
            group[day]++;
        }
        if (std::any_of(group.cbegin(), group.cend(), [nSharers](int c) { return c >= nSharers; })) {
            eq++;
        }
    }

    return (100.0 * eq) / nRepetitions;
}

int main() {
    int groupEst = 2;

    for (int sharers = 2; sharers < 6; sharers++) {
        // Coarse
        int groupSize = groupEst + 1;
        while (equalBirthdays(sharers, groupSize, 100) < 50.0) {
            groupSize++;
        }

        // Finer
        int inf = (int)(groupSize - (groupSize - groupEst) / 4.0f);
        for (int gs = inf; gs < groupSize + 999; gs++) {
            double eq = equalBirthdays(sharers, groupSize, 250);
            if (eq > 50.0) {
                groupSize = gs;
                break;
            }
        }

        // Finest
        for (int gs = groupSize - 1; gs < groupSize + 999; gs++) {
            double eq = equalBirthdays(sharers, gs, 50000);
            if (eq > 50.0) {
                groupEst = gs;
                printf("%d independant people in a group of %d share a common birthday. (%5.1f)\n", sharers, gs, eq);
                break;
            }
        }
    }

    return 0;
}
