#include <algorithm>
#include <iostream>
#include <vector>

struct Point {
    int x, y;

    //rotate/flip a quadrant appropriately
    void rot(int n, bool rx, bool ry) {
        if (!ry) {
            if (rx) {
                x = (n - 1) - x;
                y = (n - 1) - y;
            }
            std::swap(x, y);
        }
    }
};

Point fromD(int n, int d) {
    Point p = { 0, 0 };
    bool rx, ry;
    int t = d;
    for (int s = 1; s < n; s <<= 1) {
        rx = ((t & 2) != 0);
        ry = (((t ^ (rx ? 1 : 0)) & 1) != 0);
        p.rot(s, rx, ry);
        p.x += (rx ? s : 0);
        p.y += (ry ? s : 0);
        t >>= 2;
    }
    return p;
}

std::vector<Point> getPointsForCurve(int n) {
    std::vector<Point> points;
    for (int d = 0; d < n * n; ++d) {
        points.push_back(fromD(n, d));
    }
    return points;
}

std::vector<std::string> drawCurve(const std::vector<Point> &points, int n) {
    auto canvas = new char *[n];
    for (size_t i = 0; i < n; i++) {
        canvas[i] = new char[n * 3 - 2];
        std::memset(canvas[i], ' ', n * 3 - 2);
    }

    for (int i = 1; i < points.size(); i++) {
        auto lastPoint = points[i - 1];
        auto curPoint = points[i];
        int deltaX = curPoint.x - lastPoint.x;
        int deltaY = curPoint.y - lastPoint.y;
        if (deltaX == 0) {
            // vertical line
            int row = std::max(curPoint.y, lastPoint.y);
            int col = curPoint.x * 3;
            canvas[row][col] = '|';
        } else {
            // horizontal line
            int row = curPoint.y;
            int col = std::min(curPoint.x, lastPoint.x) * 3 + 1;
            canvas[row][col] = '_';
            canvas[row][col + 1] = '_';
        }
    }

    std::vector<std::string> lines;
    for (size_t i = 0; i < n; i++) {
        std::string temp;
        temp.assign(canvas[i], n * 3 - 2);
        lines.push_back(temp);
    }
    return lines;
}

int main() {
    for (int order = 1; order < 6; order++) {
        int n = 1 << order;
        auto points = getPointsForCurve(n);
        std::cout << "Hilbert curve, order=" << order << '\n';
        auto lines = drawCurve(points, n);
        for (auto &line : lines) {
            std::cout << line << '\n';
        }
        std::cout << '\n';
    }
    return 0;
}
