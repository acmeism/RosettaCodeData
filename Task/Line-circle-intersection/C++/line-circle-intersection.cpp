#include <iostream>
#include <utility>
#include <vector>

using Point = std::pair<double, double>;
constexpr auto eps = 1e-14;

std::ostream &operator<<(std::ostream &os, const Point &p) {
    auto x = p.first;
    if (x == 0.0) {
        x = 0.0;
    }
    auto y = p.second;
    if (y == 0.0) {
        y = 0.0;
    }
    return os << '(' << x << ", " << y << ')';
}

template <typename T>
std::ostream &operator<<(std::ostream &os, const std::vector<T> &v) {
    auto itr = v.cbegin();
    auto end = v.cend();

    os << '[';
    if (itr != end) {
        os << *itr;
        itr = std::next(itr);
    }
    while (itr != end) {
        os << ", " << *itr;
        itr = std::next(itr);
    }
    return os << ']';
}

double sq(double x) {
    return x * x;
}

std::vector<Point> intersects(const Point &p1, const Point &p2, const Point &cp, double r, bool segment) {
    std::vector<Point> res;
    auto x0 = cp.first;
    auto y0 = cp.second;
    auto x1 = p1.first;
    auto y1 = p1.second;
    auto x2 = p2.first;
    auto y2 = p2.second;
    auto A = y2 - y1;
    auto B = x1 - x2;
    auto C = x2 * y1 - x1 * y2;
    auto a = sq(A) + sq(B);
    double b, c;
    bool bnz = true;
    if (abs(B) >= eps) {
        b = 2 * (A * C + A * B * y0 - sq(B) * x0);
        c = sq(C) + 2 * B * C * y0 - sq(B) * (sq(r) - sq(x0) - sq(y0));
    } else {
        b = 2 * (B * C + A * B * x0 - sq(A) * y0);
        c = sq(C) + 2 * A * C * x0 - sq(A) * (sq(r) - sq(x0) - sq(y0));
        bnz = false;
    }
    auto d = sq(b) - 4 * a * c; // discriminant
    if (d < 0) {
        return res;
    }

    // checks whether a point is within a segment
    auto within = [x1, y1, x2, y2](double x, double y) {
        auto d1 = sqrt(sq(x2 - x1) + sq(y2 - y1));  // distance between end-points
        auto d2 = sqrt(sq(x - x1) + sq(y - y1));    // distance from point to one end
        auto d3 = sqrt(sq(x2 - x) + sq(y2 - y));    // distance from point to other end
        auto delta = d1 - d2 - d3;
        return abs(delta) < eps;                    // true if delta is less than a small tolerance
    };

    auto fx = [A, B, C](double x) {
        return -(A * x + C) / B;
    };

    auto fy = [A, B, C](double y) {
        return -(B * y + C) / A;
    };

    auto rxy = [segment, &res, within](double x, double y) {
        if (!segment || within(x, y)) {
            res.push_back(std::make_pair(x, y));
        }
    };

    double x, y;
    if (d == 0.0) {
        // line is tangent to circle, so just one intersect at most
        if (bnz) {
            x = -b / (2 * a);
            y = fx(x);
            rxy(x, y);
        } else {
            y = -b / (2 * a);
            x = fy(y);
            rxy(x, y);
        }
    } else {
        // two intersects at most
        d = sqrt(d);
        if (bnz) {
            x = (-b + d) / (2 * a);
            y = fx(x);
            rxy(x, y);
            x = (-b - d) / (2 * a);
            y = fx(x);
            rxy(x, y);
        } else {
            y = (-b + d) / (2 * a);
            x = fy(y);
            rxy(x, y);
            y = (-b - d) / (2 * a);
            x = fy(y);
            rxy(x, y);
        }
    }

    return res;
}

int main() {
    std::cout << "The intersection points (if any) between:\n";

    auto cp = std::make_pair(3.0, -5.0);
    auto r = 3.0;
    std::cout << "  A circle, center " << cp << " with radius " << r << ", and:\n";

    auto p1 = std::make_pair(-10.0, 11.0);
    auto p2 = std::make_pair(10.0, -9.0);
    std::cout << "    a line containing the points " << p1 << " and " << p2 << " is/are:\n";
    std::cout << "     " << intersects(p1, p2, cp, r, false) << '\n';

    p2 = std::make_pair(-10.0, 12.0);
    std::cout << "    a segment starting at " << p1 << " and ending at " << p2 << " is/are:\n";
    std::cout << "     " << intersects(p1, p2, cp, r, true) << '\n';

    p1 = std::make_pair(3.0, -2.0);
    p2 = std::make_pair(7.0, -2.0);
    std::cout << "    a horizontal line containing the points " << p1 << " and " << p2 << " is/are:\n";
    std::cout << "     " << intersects(p1, p2, cp, r, false) << '\n';

    cp = std::make_pair(0.0, 0.0);
    r = 4.0;
    std::cout << "  A circle, center " << cp << " with radius " << r << ", and:\n";

    p1 = std::make_pair(0.0, -3.0);
    p2 = std::make_pair(0.0, 6.0);
    std::cout << "    a vertical line containing the points " << p1 << " and " << p2 << " is/are:\n";
    std::cout << "     " << intersects(p1, p2, cp, r, false) << '\n';
    std::cout << "    a vertical segment containing the points " << p1 << " and " << p2 << " is/are:\n";
    std::cout << "     " << intersects(p1, p2, cp, r, true) << '\n';

    cp = std::make_pair(4.0, 2.0);
    r = 5.0;
    std::cout << "  A circle, center " << cp << " with radius " << r << ", and:\n";

    p1 = std::make_pair(6.0, 3.0);
    p2 = std::make_pair(10.0, 7.0);
    std::cout << "    a line containing the points " << p1 << " and " << p2 << " is/are:\n";
    std::cout << "     " << intersects(p1, p2, cp, r, false) << '\n';

    p1 = std::make_pair(7.0, 4.0);
    p2 = std::make_pair(11.0, 8.0);
    std::cout << "    a segment starting at " << p1 << " and ending at " << p2 << " is/are:\n";
    std::cout << "     " << intersects(p1, p2, cp, r, true) << '\n';

    return 0;
}
