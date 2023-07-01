#include <iostream>
#include <iomanip>

inline int sign(int i) {
    return i < 0 ? -1 : i > 0;
}

inline int& E(int *x, int row, int col) {
    return x[row * (row + 1) / 2 + col];
}

int iter(int *v, int *diff) {
    // enforce boundary conditions
    E(v, 0, 0) = 151;
    E(v, 2, 0) = 40;
    E(v, 4, 1) = 11;
    E(v, 4, 3) = 4;

    // calculate difference from equilibrium
    for (auto i = 1u; i < 5u; i++)
        for (auto j = 0u; j <= i; j++) {
            E(diff, i, j) = 0;
            if (j < i)
                E(diff, i, j) += E(v, i - 1, j) - E(v, i, j + 1) - E(v, i, j);
            if (j)
                E(diff, i, j) += E(v, i - 1, j - 1) - E(v, i, j - 1) - E(v, i, j);
        }

    for (auto i = 0u; i < 4u; i++)
        for (auto j = 0u; j < i; j++)
            E(diff, i, j) += E(v, i + 1, j) + E(v, i + 1, j + 1) - E(v, i, j);

    E(diff, 4, 2) += E(v, 4, 0) + E(v, 4, 4) - E(v, 4, 2);

    // do feedback, check if we are done
    uint sum;
    int e = 0;
    for (auto i = sum = 0u; i < 15u; i++) {
        sum += !!sign(e = diff[i]);

        // 1/5-ish feedback strength on average.  These numbers are highly magical, depending on nodes' connectivities
        if (e >= 4 || e <= -4)
            v[i] += e / 5;
        else if (rand() < RAND_MAX / 4)
            v[i] += sign(e);
    }
    return sum;
}

void show(int *x) {
    for (auto i = 0u; i < 5u; i++)
        for (auto j = 0u; j <= i; j++)
            std::cout << std::setw(4u) << *(x++) << (j < i ? ' ' : '\n');
}

int main() {
    int v[15] = { 0 }, diff[15] = { 0 };
    for (auto i = 1u, s = 1u; s; i++) {
        s = iter(v, diff);
        std::cout << "pass " << i << ": " << s << std::endl;
    }
    show(v);

    return 0;
}
