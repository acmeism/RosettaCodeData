#include <iostream>
#include <vector>
#include <string>
#include <cstdlib>

// Direction constants
enum Direction {
    E = 0,
    N = 1,
    W = 2,
    S = 3
};

// X generates coordinate pairs for a grid of given dimensions
std::vector<std::vector<int>> X(int a, int b) {
    std::vector<std::vector<int>> c;
    for (int aa = 0; aa <= a; aa++) {
        for (int bb = 0; bb <= b; bb++) {
            c.push_back({aa, bb});
        }
    }
    return c;
}

// any checks if any element in the vector equals val
bool any(const std::vector<int>& arr, int val) {
    for (int v : arr) {
        if (v == val) {
            return true;
        }
    }
    return false;
}

// identifyPerimeter identifies the perimeter of a shape in a 2D matrix
std::tuple<int, int, std::string> identifyPerimeter(const std::vector<std::vector<int>>& data) {
    auto coords = X(data[0].size() - 1, data.size() - 1);

    for (const auto& coord : coords) {
        int x = coord[0];
        int y = coord[1];

        if (y < data.size() && x < data[0].size() && data[y][x] != 0) {
            std::string path = "";
            int cx = x, cy = y;
            int d = 0, p = 0;

            while (true) {
                int mask = 0;

                // Check 2x2 neighborhood
                std::vector<std::vector<int>> offsets = {{0, 0, 1}, {1, 0, 2}, {0, 1, 4}, {1, 1, 8}};
                for (const auto& vals : offsets) {
                    int dx = vals[0], dy = vals[1], b = vals[2];
                    int mx = cx + dx, my = cy + dy;

                    if (mx > 0 && my > 0 && my - 1 < data.size() && mx - 1 < data[0].size() &&
                        data[my - 1][mx - 1] != 0) {
                        mask += b;
                    }
                }

                // Determine direction based on mask
                if (any({1, 5, 13}, mask)) {
                    d = N;
                }
                if (any({2, 3, 7}, mask)) {
                    d = E;
                }
                if (any({4, 12, 14}, mask)) {
                    d = W;
                }
                if (any({8, 10, 11}, mask)) {
                    d = S;
                }
                if (mask == 6) {
                    if (p == N) {
                        d = W;
                    } else {
                        d = E;
                    }
                }
                if (mask == 9) {
                    if (p == E) {
                        d = N;
                    } else {
                        d = S;
                    }
                }

                // Add direction character to path
                char dirChars[] = {'E', 'N', 'W', 'S'};
                path += dirChars[d];
                p = d;

                // Move in the determined direction
                int dxVals[] = {1, 0, -1, 0};
                int dyVals[] = {0, -1, 0, 1};
                cx += dxVals[d];
                cy += dyVals[d];

                // Check if we've returned to starting position
                if (cx == x && cy == y) {
                    break;
                }
            }

            return std::make_tuple(x, -y, path);
        }
    }

    std::cout << "That did not work out..." << std::endl;
    std::exit(1);
    return std::make_tuple(0, 0, ""); // This line will never be reached due to exit
}

int main() {
    std::vector<std::vector<int>> M = {
        {0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0},
        {0, 0, 1, 1, 0},
        {0, 0, 1, 1, 0},
        {0, 0, 0, 1, 0},
        {0, 0, 0, 0, 0}
    };

    auto [x, y, path] = identifyPerimeter(M);
    std::cout << "X: " << x << ", Y: " << y << ", Path: " << path << std::endl;

    return 0;
}
