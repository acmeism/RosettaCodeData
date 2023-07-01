#include <array>
#include <iomanip>
#include <iostream>
#include <random>
#include <sstream>

class Roulette {
private:
    std::array<bool, 6> cylinder;

    std::mt19937 gen;
    std::uniform_int_distribution<> distrib;

    int next_int() {
        return distrib(gen);
    }

    void rshift() {
        std::rotate(cylinder.begin(), cylinder.begin() + 1, cylinder.end());
    }

    void unload() {
        std::fill(cylinder.begin(), cylinder.end(), false);
    }

    void load() {
        while (cylinder[0]) {
            rshift();
        }
        cylinder[0] = true;
        rshift();
    }

    void spin() {
        int lim = next_int();
        for (int i = 1; i < lim; i++) {
            rshift();
        }
    }

    bool fire() {
        auto shot = cylinder[0];
        rshift();
        return shot;
    }

public:
    Roulette() {
        std::random_device rd;
        gen = std::mt19937(rd());
        distrib = std::uniform_int_distribution<>(1, 6);

        unload();
    }

    int method(const std::string &s) {
        unload();
        for (auto c : s) {
            switch (c) {
            case 'L':
                load();
                break;
            case 'S':
                spin();
                break;
            case 'F':
                if (fire()) {
                    return 1;
                }
                break;
            }
        }
        return 0;
    }
};

std::string mstring(const std::string &s) {
    std::stringstream ss;
    bool first = true;

    auto append = [&ss, &first](const std::string s) {
        if (first) {
            first = false;
        } else {
            ss << ", ";
        }
        ss << s;
    };

    for (auto c : s) {
        switch (c) {
        case 'L':
            append("load");
            break;
        case 'S':
            append("spin");
            break;
        case 'F':
            append("fire");
            break;
        }
    }

    return ss.str();
}

void test(const std::string &src) {
    const int tests = 100000;
    int sum = 0;

    Roulette r;
    for (int t = 0; t < tests; t++) {
        sum += r.method(src);
    }

    double pc = 100.0 * sum / tests;

    std::cout << std::left << std::setw(40) << mstring(src) << " produces " << pc << "% deaths.\n";
}

int main() {
    test("LSLSFSF");
    test("LSLSFF");
    test("LLSFSF");
    test("LLSFF");

    return 0;
}
