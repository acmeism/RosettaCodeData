#include <vector>
#include <iostream>
#include <algorithm>
#include <cmath>
#include <optional>

struct Point {
    int x;
    int y;

    bool operator==(const Point& other) const {
        return x == other.x && y == other.y;
    }

    bool operator!=(const Point& other) const {
        return !(*this == other);
    }
};

struct Line {
    Point start;
    Point end;
};

struct Polygon {
    std::vector<Point> points;
};

enum class InterVertexType {
    InsideVertex,
    OutsideVertex,
    InIntersection,
    OutIntersection
};

struct InterVertex {
    InterVertexType type;
    Point point;

    Point get_point() const {
        return point;
    }

    static std::optional<Point> get_first_in_intersection(std::vector<InterVertex>& list) {
        size_t found = 0;
        std::optional<Point> result;

        for (size_t i = 0; i < list.size(); i++) {
            if (list[i].type == InterVertexType::InIntersection) {
                found = i;
                result = list[i].get_point();
                break;
            }
        }

        if (found > 0) {
            list.erase(list.begin(), list.begin() + found);
        }

        return result;
    }
};

enum class PolyListOptionType {
    List,
    InsidePoly,
    None
};

struct PolyListOption {
    PolyListOptionType type;
    std::vector<InterVertex> interVertexList;
    std::vector<Point> points;
};

bool is_in_polygon(const Point& point, const Polygon& poly) {
    int x = point.x;
    int y = point.y;
    bool inside = false;
    size_t j = poly.points.size() - 1;

    for (size_t i = 0; i < poly.points.size(); i++) {
        int xi = poly.points[i].x;
        int yi = poly.points[i].y;
        int xj = poly.points[j].x;
        int yj = poly.points[j].y;

        bool intersect = ((yi > y) != (yj > y)) &&
                          (static_cast<double>(x) < (static_cast<double>(xj - xi) *
                          static_cast<double>(y - yi)) / static_cast<double>(yj - yi) + xi);

        if (intersect) {
            inside = !inside;
        }

        j = i;
    }

    return inside;
}

int distance_cmp(const Point& self, const Point& first, const Point& second) {
    int dst_first = std::abs(self.x - first.x) + std::abs(self.y - first.y);
    int dst_second = std::abs(self.x - second.x) + std::abs(self.y - second.y);

    if (dst_first < dst_second) {
        return -1;
    } else if (dst_first > dst_second) {
        return 1;
    } else {
        return 0;
    }
}

bool is_in_line(const Point& point, const Line& line) {
    int dxc = point.x - line.start.x;
    int dyc = point.y - line.start.y;

    int dxl = line.end.x - line.start.x;
    int dyl = line.end.y - line.start.y;

    int cross = dxc * dyl - dyc * dxl;

    if (cross != 0) {
        return false;
    }

    if (std::abs(dxl) >= std::abs(dyl)) {
        if (dxl > 0) {
            return line.start.x <= point.x && point.x <= line.end.x;
        } else {
            return line.end.x <= point.x && point.x <= line.start.x;
        }
    } else {
        if (dyl > 0) {
            return line.start.y <= point.y && point.y <= line.end.y;
        } else {
            return line.end.y <= point.y && point.y <= line.start.y;
        }
    }
}

std::optional<Point> get_intersection(const Line& self, const Line& line) {
    Point line_1_start = self.start;
    Point line_1_end = self.end;
    Point line_2_start = line.start;
    Point line_2_end = line.end;

    int den = ((line_2_end.y - line_2_start.y) * (line_1_end.x - line_1_start.x)) -
              ((line_2_end.x - line_2_start.x) * (line_1_end.y - line_1_start.y));

    if (den == 0) {
        return std::nullopt;
    }

    int a = line_1_start.y - line_2_start.y;
    int b = line_1_start.x - line_2_start.x;

    int num_1 = ((line_2_end.x - line_2_start.x) * a) - ((line_2_end.y - line_2_start.y) * b);
    int num_2 = ((line_1_end.x - line_1_start.x) * a) - ((line_1_end.y - line_1_start.y) * b);

    double a_f = static_cast<double>(num_1) / static_cast<double>(den);
    double b_f = static_cast<double>(num_2) / static_cast<double>(den);

    if (a_f < 0.0 || a_f > 1.0 || b_f < 0.0 || b_f > 1.0) {
        return std::nullopt;
    }

    Point result = {
        line_1_start.x + static_cast<int>(std::round(a_f * (line_1_end.x - line_1_start.x))),
        line_1_start.y + static_cast<int>(std::round(a_f * (line_1_end.y - line_1_start.y)))
    };

    return result;
}

bool is_clockwise(const Polygon& poly) {
    int sum = 0;
    for (size_t i = 0; i < poly.points.size(); i++) {
        size_t j = (i != poly.points.size() - 1) ? i + 1 : 0;
        sum += (poly.points[j].x - poly.points[i].x) * (poly.points[j].y + poly.points[i].y);
    }
    return sum < 0;
}

Polygon get_reversed(const Polygon& poly) {
    std::vector<Point> reversed_points = poly.points;
    std::reverse(reversed_points.begin(), reversed_points.end());
    return Polygon{reversed_points};
}

std::optional<size_t> get_first_outside_vertex_index(const Polygon& subject, const Polygon& poly) {
    for (size_t i = 0; i < subject.points.size(); i++) {
        if (!is_in_polygon(subject.points[i], poly)) {
            return i;
        }
    }
    return std::nullopt;
}

std::optional<size_t> get_first_inside_vertex_index(const Polygon& subject, const Polygon& poly) {
    for (size_t i = 0; i < subject.points.size(); i++) {
        if (is_in_polygon(subject.points[i], poly)) {
            return i;
        }
    }
    return std::nullopt;
}

std::vector<InterVertex> get_intersections_with_line(const Polygon& poly, const Line& line, bool* cursor_inside) {
    std::vector<Point> intersections;

    for (size_t i = 0; i < poly.points.size(); i++) {
        const Point& start = poly.points[i];
        size_t next_i = (i == poly.points.size() - 1) ? 0 : i + 1;
        const Point& end = poly.points[next_i];

        Line l = {start, end};
        auto intersection = get_intersection(l, line);

        if (intersection && *intersection != line.start && *intersection != line.end &&
            *intersection != start && *intersection != end) {
            intersections.push_back(*intersection);
        }
    }

    std::sort(intersections.begin(), intersections.end(),
        [&line](const Point& a, const Point& b) {
            return distance_cmp(line.start, a, b) < 0;
        });

    std::vector<InterVertex> result;
    for (const auto& x : intersections) {
        if (*cursor_inside) {
            *cursor_inside = !*cursor_inside;
            result.push_back({InterVertexType::OutIntersection, x});
        } else {
            *cursor_inside = !*cursor_inside;
            result.push_back({InterVertexType::InIntersection, x});
        }
    }

    return result;
}

PolyListOption get_inter_vertex_list(const Polygon& subject, const Polygon& poly) {
    Polygon subject_copy = subject;
    if (!is_clockwise(subject_copy)) {
        subject_copy = get_reversed(subject_copy);
    }

    bool cursor_inside = false;
    int intersection_count = 0;

    auto start_index_opt = get_first_outside_vertex_index(subject_copy, poly);
    if (start_index_opt) {
        size_t start_index = *start_index_opt;

        if (!get_first_inside_vertex_index(subject_copy, poly)) {
            bool all_inside = true;
            for (const auto& point : poly.points) {
                if (!is_in_polygon(point, subject_copy)) {
                    all_inside = false;
                    break;
                }
            }

            if (all_inside) {
                return {PolyListOptionType::InsidePoly, {}, poly.points};
            }
        }

        std::vector<InterVertex> result;

        for (size_t i_offset = 0; i_offset < subject_copy.points.size(); i_offset++) {
            size_t i = (start_index + i_offset) % subject_copy.points.size();
            const Point& start = subject_copy.points[i];

            // Check vertex
            if (i != start_index && is_in_polygon(start, poly)) {
                result.push_back({InterVertexType::InsideVertex, start});
            } else {
                result.push_back({InterVertexType::OutsideVertex, start});
            }

            // Check intersection
            size_t next_i = (i == subject_copy.points.size() - 1) ? 0 : i + 1;
            Point end = subject_copy.points[next_i];
            Line line = {start, end};

            auto intersections = get_intersections_with_line(poly, line, &cursor_inside);
            intersection_count += intersections.size();

            result.insert(result.end(), intersections.begin(), intersections.end());
        }

        // Check if there are any intersections
        bool has_intersections = false;
        for (const auto& vertex : result) {
            if (vertex.type == InterVertexType::InIntersection ||
                vertex.type == InterVertexType::OutIntersection) {
                has_intersections = true;
                break;
            }
        }

        if (!has_intersections) {
            return {PolyListOptionType::None, {}, {}};
        } else {
            return {PolyListOptionType::List, result, {}};
        }
    } else {
        return {PolyListOptionType::InsidePoly, {}, subject.points};
    }
}

std::optional<std::pair<std::vector<Point>, Point>> collect_from_list(std::vector<InterVertex>& list, Point start_point) {
    bool initial_vertex_not_found = true;
    std::optional<Point> last_point;
    size_t start_i = 0, end_i = 0;
    bool dont_skip = list[0].get_point() == start_point;

    std::vector<Point> points;
    size_t i = 0;

    // Skip until InIntersection occurs, but include the InIntersection
    while (i < list.size() && initial_vertex_not_found && !dont_skip) {
        size_t next = (i == list.size() - 1) ? 0 : i + 1;
        auto& next_point = list[next];

        if (next_point.type == InterVertexType::InIntersection ||
            next_point.type == InterVertexType::OutIntersection) {
            if (next_point.get_point() == start_point) {
                start_i = next;
                initial_vertex_not_found = false;
                break;
            }
        }
        i++;
    }

    // Collect points
    if (!initial_vertex_not_found || dont_skip) {
        i = start_i;
        bool continue_collecting = true;

        while (continue_collecting && i < list.size()) {
            auto& vertex = list[i];

            if (vertex.type == InterVertexType::OutIntersection) {
                end_i = i;
                last_point = vertex.get_point();
                continue_collecting = false;
            } else {
                points.push_back(vertex.get_point());
            }

            i++;
        }
    }

    size_t amount = end_i - start_i + 1;
    if (end_i >= start_i && start_i + amount <= list.size()) {
        list.erase(list.begin() + start_i, list.begin() + start_i + amount);
    }

    if (!points.empty() && last_point) {
        return std::make_pair(points, *last_point);
    } else {
        return std::nullopt;
    }
}

std::optional<std::vector<Point>> get_clip_polygon(
    std::vector<InterVertex>& subject,
    std::vector<InterVertex>& clip,
    Point initial) {

    std::vector<Point> result;
    bool subject_as_list = true;
    Point start_point = initial;
    Point end_point = subject.back().get_point();

    while (!(initial == end_point)) {
        auto values = collect_from_list(
            subject_as_list ? subject : clip,
            start_point);

        if (values) {
            auto [edges, end] = *values;
            end_point = end;
            start_point = end;
            subject_as_list = !subject_as_list;

            result.insert(result.end(), edges.begin(), edges.end());
        } else {
            std::cout << "something went wrong" << std::endl;
            std::cout << "res size: " << result.size() << std::endl;
            return std::nullopt;
        }
    }

    if (!result.empty()) {
        // Filter consecutive duplicate points
        auto new_end = std::unique(result.begin(), result.end(),
            [](const Point& a, const Point& b) { return a == b; });
        result.erase(new_end, result.end());

        return result;
    } else {
        return std::nullopt;
    }
}

std::optional<std::vector<std::vector<Point>>> get_clip_polygons(
    std::vector<InterVertex>& subject,
    std::vector<InterVertex>& clip) {

    std::vector<std::vector<Point>> result;

    while (true) {
        auto start_point_opt = InterVertex::get_first_in_intersection(subject);
        if (!start_point_opt) {
            break;
        }

        auto poly = get_clip_polygon(subject, clip, *start_point_opt);
        if (poly) {
            result.push_back(*poly);
        } else {
            break;
        }
    }

    if (!result.empty()) {
        return result;
    } else {
        return std::nullopt;
    }
}

std::optional<std::vector<std::vector<Point>>> clip(const Polygon& self, const Polygon& other) {
    auto option = get_inter_vertex_list(self, other);
    auto other_option = get_inter_vertex_list(other, self);

    if (option.type == PolyListOptionType::List) {
        auto subject_list = option.interVertexList;

        if (other_option.type == PolyListOptionType::List) {
            auto clip_list = other_option.interVertexList;
            return get_clip_polygons(subject_list, clip_list);
        } else if (other_option.type == PolyListOptionType::InsidePoly) {
            std::vector<std::vector<Point>> result;
            result.push_back(other_option.points);
            return result;
        } else { // None
            return std::nullopt;
        }
    } else if (option.type == PolyListOptionType::InsidePoly) {
        std::vector<std::vector<Point>> result;
        result.push_back(option.points);
        return result;
    } else { // None
        return std::nullopt;
    }
}

// Testing function
void run_tests() {
    // Test is_in_line
    {
        Point p = {5, 10};
        Line line = {{5, 5}, {5, 20}};
        bool result = is_in_line(p, line);
        std::cout << "is_in_line test 1: " << (result ? "PASS" : "FAIL") << std::endl;

        Point p_f = {3, 4};
        Line line_f = {{5, 5}, {5, 20}};
        bool result_f = is_in_line(p_f, line_f);
        std::cout << "is_in_line test 2: " << (!result_f ? "PASS" : "FAIL") << std::endl;
    }

    // Test clip
    {
        Polygon poly = {
            {{180, 420}, {180, 120}, {520, 120}, {520, 420}, {420, 420}, {320, 220}}
        };

        Polygon inter_polygon = {
            {{60, 220}, {330, 120}, {410, 290}, {80, 480}, {280, 280}}
        };

        auto polygons = clip(poly, inter_polygon);
        if (polygons && !polygons->empty()) {
            std::cout << "clip test: PASS - Found " << polygons->size() << " polygons" << std::endl;

            // Print first polygon points
            if (!(*polygons)[0].empty()) {
                std::cout << "First polygon points:" << std::endl;
                for (const auto& p : (*polygons)[0]) {
                    std::cout << "  Point: (" << p.x << ", " << p.y << ")" << std::endl;
                }
            }
        } else {
            std::cout << "clip test: FAIL - No polygons found" << std::endl;
        }
    }
}

int main() {
    run_tests();
    return 0;
}
