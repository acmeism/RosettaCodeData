#include <iostream>
#include <numeric>
#include <vector>

template <typename T>
std::ostream &operator<<(std::ostream &os, const std::vector<T> &v) {
    auto it = v.cbegin();
    auto end = v.cend();

    os << '[';
    if (it != end) {
        os << *it;
        it = std::next(it);
    }
    while (it != end) {
        os << ", " << *it;
        it = std::next(it);
    }

    return os << ']';
}

std::vector<int> demand = { 30, 20, 70, 30, 60 };
std::vector<int> supply = { 50, 60, 50, 50 };
std::vector<std::vector<int>> costs = {
    {16, 16, 13, 22, 17},
    {14, 14, 13, 19, 15},
    {19, 19, 20, 23, 50},
    {50, 12, 50, 15, 11}
};

int nRows = supply.size();
int nCols = demand.size();

std::vector<bool> rowDone(nRows, false);
std::vector<bool> colDone(nCols, false);
std::vector<std::vector<int>> result(nRows, std::vector<int>(nCols, 0));

std::vector<int> diff(int j, int len, bool isRow) {
    int min1 = INT_MAX;
    int min2 = INT_MAX;
    int minP = -1;
    for (int i = 0; i < len; i++) {
        if (isRow ? colDone[i] : rowDone[i]) {
            continue;
        }
        int c = isRow
            ? costs[j][i]
            : costs[i][j];
        if (c < min1) {
            min2 = min1;
            min1 = c;
            minP = i;
        } else if (c < min2) {
            min2 = c;
        }
    }
    return { min2 - min1, min1, minP };
}

std::vector<int> maxPenalty(int len1, int len2, bool isRow) {
    int md = INT_MIN;
    int pc = -1;
    int pm = -1;
    int mc = -1;
    for (int i = 0; i < len1; i++) {
        if (isRow ? rowDone[i] : colDone[i]) {
            continue;
        }
        std::vector<int> res = diff(i, len2, isRow);
        if (res[0] > md) {
            md = res[0];    // max diff
            pm = i;         // pos of max diff
            mc = res[1];    // min cost
            pc = res[2];    // pos of min cost
        }
    }
    return isRow
        ? std::vector<int> { pm, pc, mc, md }
    : std::vector<int>{ pc, pm, mc, md };
}

std::vector<int> nextCell() {
    auto res1 = maxPenalty(nRows, nCols, true);
    auto res2 = maxPenalty(nCols, nRows, false);

    if (res1[3] == res2[3]) {
        return res1[2] < res2[2]
            ? res1
            : res2;
    }
    return res1[3] > res2[3]
        ? res2
        : res1;
}

int main() {
    int supplyLeft = std::accumulate(supply.cbegin(), supply.cend(), 0, [](int a, int b) { return a + b; });
    int totalCost = 0;

    while (supplyLeft > 0) {
        auto cell = nextCell();
        int r = cell[0];
        int c = cell[1];

        int quantity = std::min(demand[c], supply[r]);

        demand[c] -= quantity;
        if (demand[c] == 0) {
            colDone[c] = true;
        }

        supply[r] -= quantity;
        if (supply[r] == 0) {
            rowDone[r] = true;
        }

        result[r][c] = quantity;
        supplyLeft -= quantity;

        totalCost += quantity * costs[r][c];
    }

    for (auto &a : result) {
        std::cout << a << '\n';
    }

    std::cout << "Total cost: " << totalCost;

    return 0;
}
