#include <iostream>
#include <vector>
#include <string>
#include <random>

int main() {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<int> d4(0, 3);
    std::uniform_int_distribution<int> d2(0, 1);
    int xp = 127, yp = 127, a = 0, na = 0, f = d4(gen);

    std::vector<int> x;
    std::vector<int> y;
    std::vector<int> e;

    while (true) {
        a = na;
        for (int n = 0; n < na; n++) {
            if (x[n] == xp && y[n] == yp) {
                a = n;
                break;
            }
        }

        if (a == na) {
            na++;
            x.resize(na);
            y.resize(na);
            e.resize(4 * na);

            x[a] = xp;
            y[a] = yp;

            for (int n = 0; n < 4; n++) {
                e[4 * a + n] = d2(gen);
            }

            for (int n = 0; n < na; n++) {
                if (x[n] == x[a] + 1 && y[n] == y[a]) {
                    e[4 * a + 0] = e[4 * n + 2];
                } else if (x[n] == x[a] && y[n] == y[a] + 1) {
                    e[4 * a + 1] = e[4 * n + 3];
                } else if (x[n] == x[a] - 1 && y[n] == y[a]) {
                    e[4 * a + 2] = e[4 * n + 0];
                } else if (x[n] == x[a] && y[n] == y[a] - 1) {
                    e[4 * a + 3] = e[4 * n + 1];
                }
            }
        }

        std::cout << "Paths:";
        if (e[4 * a + (f) % 4]) std::cout << " ahead";
        if (e[4 * a + (f + 1) % 4]) std::cout << " right";
        if (e[4 * a + (f + 2) % 4]) std::cout << " back";
        if (e[4 * a + (f + 3) % 4]) std::cout << " left";
        std::cout << std::endl;

        int d = -1;
        std::string entry;

        while (d < 0) {
            std::cout << "> ";
            std::cin >> entry;

            if (entry == "ahead") {
                d = f % 4;
            } else if (entry == "right") {
                d = (f + 1) % 4;
            } else if (entry == "back") {
                d = (f + 2) % 4;
            } else if (entry == "left") {
                d = (f + 3) % 4;
            } else if (entry == "quit") {
                return 0;
            } else {
                std::cout << "Invalid." << std::endl;
                continue;
            }

            switch (d) {
                case 0:
                    if (e[4 * a + 0]) {
                        xp++;
                        f = d;
                    } else {
                        d = -1;
                    }
                    break;
                case 1:
                    if (e[4 * a + 1]) {
                        yp++;
                        f = d;
                    } else {
                        d = -1;
                    }
                    break;
                case 2:
                    if (e[4 * a + 2]) {
                        xp--;
                        f = d;
                    } else {
                        d = -1;
                    }
                    break;
                case 3:
                    if (e[4 * a + 3]) {
                        yp--;
                        f = d;
                    } else {
                        d = -1;
                    }
                    break;
            }

            if (d < 0) {
                std::cout << "No path." << std::endl;
            }
        }
    }
}
