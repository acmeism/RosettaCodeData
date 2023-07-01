#include <iostream>
#include <vector>

std::vector<long> TREE_LIST;
std::vector<int> OFFSET;

void init() {
    for (size_t i = 0; i < 32; i++) {
        if (i == 1) {
            OFFSET.push_back(1);
        } else {
            OFFSET.push_back(0);
        }
    }
}

void append(long t) {
    TREE_LIST.push_back(1 | (t << 1));
}

void show(long t, int l) {
    while (l-- > 0) {
        if (t % 2 == 1) {
            std::cout << '(';
        } else {
            std::cout << ')';
        }
        t = t >> 1;
    }
}

void listTrees(int n) {
    for (int i = OFFSET[n]; i < OFFSET[n + 1]; i++) {
        show(TREE_LIST[i], 2 * n);
        std::cout << '\n';
    }
}

void assemble(int n, long t, int sl, int pos, int rem) {
    if (rem == 0) {
        append(t);
        return;
    }

    auto pp = pos;
    auto ss = sl;

    if (sl > rem) {
        ss = rem;
        pp = OFFSET[ss];
    } else if (pp >= OFFSET[ss + 1]) {
        ss--;
        if (ss == 0) {
            return;
        }
        pp = OFFSET[ss];
    }

    assemble(n, t << (2 * ss) | TREE_LIST[pp], ss, pp, rem - ss);
    assemble(n, t, ss, pp + 1, rem);
}

void makeTrees(int n) {
    if (OFFSET[n + 1] != 0) {
        return;
    }
    if (n > 0) {
        makeTrees(n - 1);
    }
    assemble(n, 0, n - 1, OFFSET[n - 1], n - 1);
    OFFSET[n + 1] = TREE_LIST.size();
}

void test(int n) {
    if (n < 1 || n > 12) {
        throw std::runtime_error("Argument must be between 1 and 12");
    }

    append(0);

    makeTrees(n);
    std::cout << "Number of " << n << "-trees: " << OFFSET[n + 1] - OFFSET[n] << '\n';
    listTrees(n);
}

int main() {
    init();
    test(5);

    return 0;
}
