#include <array>
#include <iostream>
#include <stack>
#include <vector>

const std::array<std::pair<int, int>, 4> DIRS = {
    std::make_pair(0, -1),
    std::make_pair(-1,  0),
    std::make_pair(0,  1),
    std::make_pair(1,  0),
};

void printResult(const std::vector<std::vector<int>> &v) {
    for (auto &row : v) {
        auto it = row.cbegin();
        auto end = row.cend();

        std::cout << '[';
        if (it != end) {
            std::cout << *it;
            it = std::next(it);
        }
        while (it != end) {
            std::cout << ", " << *it;
            it = std::next(it);
        }
        std::cout << "]\n";
    }
}

void cutRectangle(int w, int h) {
    if (w % 2 == 1 && h % 2 == 1) {
        return;
    }

    std::vector<std::vector<int>> grid(h, std::vector<int>(w));
    std::stack<int> stack;

    int half = (w * h) / 2;
    long bits = (long)pow(2, half) - 1;

    for (; bits > 0; bits -= 2) {
        for (int i = 0; i < half; i++) {
            int r = i / w;
            int c = i % w;
            grid[r][c] = (bits & (1 << i)) != 0 ? 1 : 0;
            grid[h - r - 1][w - c - 1] = 1 - grid[r][c];
        }

        stack.push(0);
        grid[0][0] = 2;
        int count = 1;
        while (!stack.empty()) {
            int pos = stack.top();
            stack.pop();

            int r = pos / w;
            int c = pos % w;
            for (auto dir : DIRS) {
                int nextR = r + dir.first;
                int nextC = c + dir.second;

                if (nextR >= 0 && nextR < h && nextC >= 0 && nextC < w) {
                    if (grid[nextR][nextC] == 1) {
                        stack.push(nextR * w + nextC);
                        grid[nextR][nextC] = 2;
                        count++;
                    }
                }
            }
        }
        if (count == half) {
            printResult(grid);
            std::cout << '\n';
        }
    }
}

int main() {
    cutRectangle(2, 2);
    cutRectangle(4, 3);

    return 0;
}
