#include <algorithm>
#include <iostream>
#include <ostream>
#include <vector>
#include <tuple>

typedef std::tuple<int, int> point;

std::ostream& print(std::ostream& os, const point& p) {
    return os << "(" << std::get<0>(p) << ", " << std::get<1>(p) << ")";
}

std::ostream& print(std::ostream& os, const std::vector<point>& v) {
    auto it = v.cbegin();
    auto end = v.cend();

    os << "[";

    if (it != end) {
        print(os, *it);
        it = std::next(it);
    }
    while (it != end) {
        os << ", ";
        print(os, *it);
        it = std::next(it);
    }

    return os << "]";
}

// returns true if the three points make a counter-clockwise turn
bool ccw(const point& a, const point& b, const point& c) {
    return ((std::get<0>(b) - std::get<0>(a)) * (std::get<1>(c) - std::get<1>(a)))
         > ((std::get<1>(b) - std::get<1>(a)) * (std::get<0>(c) - std::get<0>(a)));
}

std::vector<point> convexHull(std::vector<point> p) {
    if (p.size() == 0) return std::vector<point>();
    std::sort(p.begin(), p.end(), [](point& a, point& b){
        if (std::get<0>(a) < std::get<0>(b)) return true;
        return false;
    });

    std::vector<point> h;

    // lower hull
    for (const auto& pt : p) {
        while (h.size() >= 2 && !ccw(h.at(h.size() - 2), h.at(h.size() - 1), pt)) {
            h.pop_back();
        }
        h.push_back(pt);
    }

    // upper hull
    auto t = h.size() + 1;
    for (auto it = p.crbegin(); it != p.crend(); it = std::next(it)) {
        auto pt = *it;
        while (h.size() >= t && !ccw(h.at(h.size() - 2), h.at(h.size() - 1), pt)) {
            h.pop_back();
        }
        h.push_back(pt);
    }

    h.pop_back();
    return h;
}

int main() {
    using namespace std;

    vector<point> points = {
        make_pair(16, 3),  make_pair(12, 17), make_pair(0,  6),  make_pair(-4, -6), make_pair(16,  6),
        make_pair(16, -7), make_pair(16, -3), make_pair(17, -4), make_pair(5, 19),  make_pair(19, -8),
        make_pair(3, 16),  make_pair(12, 13), make_pair(3, -4),  make_pair(17,  5), make_pair(-3, 15),
        make_pair(-3, -9), make_pair(0, 11),  make_pair(-9, -3), make_pair(-4, -2), make_pair(12, 10)
    };

    auto hull = convexHull(points);
    auto it = hull.cbegin();
    auto end = hull.cend();

    cout << "Convex Hull: ";
    print(cout, hull);
    cout << endl;

    return 0;
}
