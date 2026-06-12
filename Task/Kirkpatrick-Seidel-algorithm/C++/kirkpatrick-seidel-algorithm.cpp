// Ported from  https://gist.github.com/neizod/9a367847c03fc47d7f267004de5c05ec



#include <iostream>
#include <vector>
#include <set>
#include <algorithm>
#include <cstdlib>
#include <ctime>
#include <limits>

struct Point {
    double x;
    double y;

    Point() : x(0), y(0) {}
    Point(double x, double y) : x(x), y(y) {}

    bool operator<(const Point& other) const {
        if (x == other.x) {
            return y < other.y;
        }
        return x < other.x;
    }

    bool operator==(const Point& other) const {
        return x == other.x && y == other.y;
    }

    bool operator!=(const Point& other) const {
        return !(*this == other);
    }
};

std::vector<Point> flipped(const std::vector<Point>& points) {
    std::vector<Point> result;
    for (const auto& point : points) {
        result.push_back(Point(-point.x, -point.y));
    }
    return result;
}

template <typename T>
T quickselect(std::vector<T>& ls, int index, int lo = 0, int hi = -1, int depth = 0) {
    if (hi == -1) {
        hi = ls.size() - 1;
    }

    if (lo == hi) {
        return ls[lo];
    }

    int pivot = lo + rand() % (hi - lo + 1);
    std::swap(ls[lo], ls[pivot]);

    int cur = lo;
    for (int run = lo + 1; run <= hi; run++) {
        if (ls[run] < ls[lo]) {
            cur++;
            std::swap(ls[cur], ls[run]);
        }
    }

    std::swap(ls[cur], ls[lo]);

    if (index < cur) {
        return quickselect(ls, index, lo, cur - 1, depth + 1);
    } else if (index > cur) {
        return quickselect(ls, index, cur + 1, hi, depth + 1);
    } else {
        return ls[cur];
    }
}

std::pair<Point, Point> bridge(std::set<Point> points, double vertical_line) {
    std::set<Point> candidates;

    if (points.size() == 2) {
        auto it = points.begin();
        Point first = *it;
        ++it;
        Point second = *it;
        return {first, second};
    }

    std::vector<std::pair<Point, Point>> pairs;
    std::set<Point> modify_s = points;

    while (modify_s.size() >= 2) {
        auto it1 = modify_s.begin();
        Point p1 = *it1;
        modify_s.erase(it1);

        auto it2 = modify_s.begin();
        Point p2 = *it2;
        modify_s.erase(it2);

        if (p1 < p2) {
            pairs.push_back({p1, p2});
        } else {
            pairs.push_back({p2, p1});
        }
    }

    if (modify_s.size() == 1) {
        candidates.insert(*modify_s.begin());
    }

    std::vector<double> slopes;

    for (auto it = pairs.begin(); it != pairs.end();) {
        const auto& [pi, pj] = *it;

        if (pi.x == pj.x) {
            candidates.insert(pi.y > pj.y ? pi : pj);
            it = pairs.erase(it);
        } else {
            slopes.push_back((pi.y - pj.y) / (pi.x - pj.x));
            ++it;
        }
    }

    if (slopes.empty()) {
        // Handle case when no valid pairs with slopes are found
        if (candidates.size() >= 2) {
            auto it = candidates.begin();
            Point p1 = *it;
            ++it;
            Point p2 = *it;
            return {p1, p2};
        }
        // If we don't have enough candidates, return the first pair
        return {*points.begin(), *std::next(points.begin())};
    }

    int median_index = slopes.size() / 2 - (slopes.size() % 2 == 0 ? 1 : 0);
    double median_slope = quickselect(slopes, median_index);

    std::set<std::pair<Point, Point>> small, equal, large;

    for (size_t i = 0; i < slopes.size(); i++) {
        if (slopes[i] < median_slope) {
            small.insert(pairs[i]);
        } else if (slopes[i] == median_slope) {
            equal.insert(pairs[i]);
        } else {
            large.insert(pairs[i]);
        }
    }

    double max_slope = -std::numeric_limits<double>::infinity();
    for (const auto& point : points) {
        max_slope = std::max(max_slope, point.y - median_slope * point.x);
    }

    std::vector<Point> max_set;
    for (const auto& point : points) {
        if (point.y - median_slope * point.x == max_slope) {
            max_set.push_back(point);
        }
    }

    Point left = *std::min_element(max_set.begin(), max_set.end());
    Point right = *std::max_element(max_set.begin(), max_set.end());

    if (left.x <= vertical_line && right.x > vertical_line) {
        return {left, right};
    }

    if (right.x <= vertical_line) {
        for (const auto& pair : large) {
            candidates.insert(pair.second);
        }
        for (const auto& pair : equal) {
            candidates.insert(pair.second);
        }
        for (const auto& pair : small) {
            candidates.insert(pair.first);
            candidates.insert(pair.second);
        }
    }

    if (left.x > vertical_line) {
        for (const auto& pair : small) {
            candidates.insert(pair.first);
        }
        for (const auto& pair : equal) {
            candidates.insert(pair.first);
        }
        for (const auto& pair : large) {
            candidates.insert(pair.first);
            candidates.insert(pair.second);
        }
    }

    return bridge(candidates, vertical_line);
}

std::vector<Point> connect(const Point& lower, const Point& upper, const std::set<Point>& points) {
    if (lower == upper) {
        return {lower};
    }

    std::vector<Point> points_vec(points.begin(), points.end());
    int mid_index = points_vec.size() / 2 - 1;

    Point max_left = quickselect(points_vec, mid_index);
    Point min_right = quickselect(points_vec, mid_index + 1);

    auto [left, right] = bridge(points, (max_left.x + min_right.x) / 2);

    std::set<Point> points_left = {left};
    std::set<Point> points_right = {right};

    for (const auto& point : points) {
        if (point.x < left.x) {
            points_left.insert(point);
        } else if (point.x > right.x) {
            points_right.insert(point);
        }
    }

    std::vector<Point> left_result = connect(lower, left, points_left);
    std::vector<Point> right_result = connect(right, upper, points_right);

    left_result.insert(left_result.end(), right_result.begin(), right_result.end());
    return left_result;
}

std::vector<Point> upper_hull(const std::set<Point>& points) {
    Point lower = *points.begin();

    // Find the lowest point with the same x-coordinate as the minimum
    for (const auto& point : points) {
        if (point.x == lower.x && point.y > lower.y) {
            lower = point;
        }
    }

    Point upper = *points.rbegin();

    std::set<Point> filtered_points = {lower, upper};
    for (const auto& p : points) {
        if (lower.x < p.x && p.x < upper.x) {
            filtered_points.insert(p);
        }
    }

    return connect(lower, upper, filtered_points);
}

std::vector<Point> convex_hull(const std::set<Point>& points) {
    std::vector<Point> upper = upper_hull(points);

    std::set<Point> flipped_points;
    for (const auto& p : points) {
        flipped_points.insert(Point(-p.x, -p.y));
    }

    std::vector<Point> flipped_upper = upper_hull(flipped_points);
    std::vector<Point> lower = flipped(flipped_upper);

    if (upper.back() == lower.front()) {
        upper.pop_back();
    }

    if (upper.front() == lower.back()) {
        lower.pop_back();
    }

    std::vector<Point> result = upper;
    result.insert(result.end(), lower.begin(), lower.end());

    return result;
}

// Test case for a simplex
int main() {
    srand(time(nullptr));

    // Create points for a 2D projection of a 3D simplex
    std::set<Point> points = {
        Point(0.0, 0.0),   // projection of [0.0, 0.0, 0.0]
        Point(1.0, 0.0),   // projection of [1.0, 0.0, 0.0]
        Point(0.0, 1.0),   // projection of [0.0, 1.0, 0.0]
        Point(0.5, 0.5)    // projection of [0.0, 0.0, 1.0] (projected to 2D)
    };

    std::cout << "Input points:" << std::endl;
    for (const auto& p : points) {
        std::cout << "(" << p.x << ", " << p.y << ")" << std::endl;
    }

    std::vector<Point> hull = convex_hull(points);

    std::cout << "\nConvex hull points:" << std::endl;
    for (const auto& p : hull) {
        std::cout << "(" << p.x << ", " << p.y << ")" << std::endl;
    }

    return 0;
}
