#include <array>
#include <iostream>
#include <vector>

std::vector<std::pair<int, int>> connections = {
    {0, 2}, {0, 3}, {0, 4}, // A to C,D,E
    {1, 3}, {1, 4}, {1, 5}, // B to D,E,F
    {6, 2}, {6, 3}, {6, 4}, // G to C,D,E
    {7, 3}, {7, 4}, {7, 5}, // H to D,E,F
    {2, 3}, {3, 4}, {4, 5}, // C-D, D-E, E-F
};
std::array<int, 8> pegs;
int num = 0;

void printSolution() {
    std::cout << "----- " << num++ << " -----\n";
    std::cout << "  " /*     */ << pegs[0] << ' ' << pegs[1] << '\n';
    std::cout << pegs[2] << ' ' << pegs[3] << ' ' << pegs[4] << ' ' << pegs[5] << '\n';
    std::cout << "  " /*     */ << pegs[6] << ' ' << pegs[7] << '\n';
    std::cout << '\n';
}

bool valid() {
    for (size_t i = 0; i < connections.size(); i++) {
        if (abs(pegs[connections[i].first] - pegs[connections[i].second]) == 1) {
            return false;
        }
    }
    return true;
}

void solution(int le, int ri) {
    if (le == ri) {
        if (valid()) {
            printSolution();
        }
    } else {
        for (size_t i = le; i <= ri; i++) {
            std::swap(pegs[le], pegs[i]);
            solution(le + 1, ri);
            std::swap(pegs[le], pegs[i]);
        }
    }
}

int main() {
    pegs = { 1, 2, 3, 4, 5, 6, 7, 8 };
    solution(0, pegs.size() - 1);
    return 0;
}
