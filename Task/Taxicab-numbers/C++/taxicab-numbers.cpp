#include <algorithm>
#include <iomanip>
#include <iostream>
#include <map>
#include <sstream>
#include <vector>

template <typename T>
size_t indexOf(const std::vector<T> &v, const T &k) {
    auto it = std::find(v.cbegin(), v.cend(), k);

    if (it != v.cend()) {
        return it - v.cbegin();
    }
    return -1;
}

int main() {
    std::vector<size_t> cubes;

    auto dump = [&cubes](const std::string &title, const std::map<int, size_t> &items) {
        std::cout << title;
        for (auto &item : items) {
            std::cout << "\n" << std::setw(4) << item.first << " " << std::setw(10) << item.second;
            for (auto x : cubes) {
                auto y = item.second - x;
                if (y < x) {
                    break;
                }
                if (std::count(cubes.begin(), cubes.end(), y)) {
                    std::cout << " = " << std::setw(4) << indexOf(cubes, y) << "^3 + " << std::setw(3) << indexOf(cubes, x) << "^3";
                }
            }
        }
    };

    std::vector<size_t> sums;

    // create sorted list of cube sums
    for (size_t i = 0; i < 1190; i++) {
        auto cube = i * i * i;
        cubes.push_back(cube);
        for (auto j : cubes) {
            sums.push_back(cube + j);
        }
    }
    std::sort(sums.begin(), sums.end());

    // now seek consecutive sums that match
    auto nm1 = sums[0];
    auto n = sums[1];
    int idx = 0;
    std::map<int, size_t> task;
    std::map<int, size_t> trips;

    auto it = sums.cbegin();
    auto end = sums.cend();
    it++;
    it++;

    while (it != end) {
        auto np1 = *it;

        if (nm1 == np1) {
            trips.emplace(idx, n);
        }
        if (nm1 != n && n == np1) {
            if (++idx <= 25 || idx >= 2000 == idx <= 2006) {
                task.emplace(idx, n);
            }
        }
        nm1 = n;
        n = np1;

        it++;
    }

    dump("First 25 Taxicab Numbers, the 2000th, plus the next half-dozen:", task);

    std::stringstream ss;
    ss << "\n\nFound " << trips.size() << " triple Taxicabs under 2007:";
    dump(ss.str(), trips);

    return 0;
}
