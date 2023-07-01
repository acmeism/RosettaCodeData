#include <iostream>
#include <span>
#include <vector>

struct vec2 {
    float x = 0.0f, y = 0.0f;

    constexpr vec2 operator+(vec2 other) const {
        return vec2{x + other.x, y + other.y};
    }

    constexpr vec2 operator-(vec2 other) const {
        return vec2{x - other.x, y - other.y};
    }
};

constexpr vec2 operator*(vec2 a, float b) { return vec2{a.x * b, a.y * b}; }

constexpr float dot(vec2 a, vec2 b) { return a.x * b.x + a.y * b.y; }

constexpr float cross(vec2 a, vec2 b) { return a.x * b.y - b.x * a.y; }

// check if a point is on the LEFT side of an edge
constexpr bool is_inside(vec2 point, vec2 a, vec2 b) {
    return (cross(a - b, point) + cross(b, a)) < 0.0f;
}

// calculate intersection point
constexpr vec2 intersection(vec2 a1, vec2 a2, vec2 b1, vec2 b2) {
    return ((b1 - b2) * cross(a1, a2) - (a1 - a2) * cross(b1, b2)) *
           (1.0f / cross(a1 - a2, b1 - b2));
}

// Sutherland-Hodgman clipping
std::vector<vec2> suther_land_hodgman(
    std::span<vec2 const> subject_polygon, std::span<vec2 const> clip_polygon) {
    if (clip_polygon.empty() || subject_polygon.empty()) {
        return {};
    }

    std::vector<vec2> ring{subject_polygon.begin(), subject_polygon.end()};

    vec2 p1 = clip_polygon[clip_polygon.size() - 1];

    std::vector<vec2> input;

    for (vec2 p2 : clip_polygon) {
        input.clear();
        input.insert(input.end(), ring.begin(), ring.end());
        vec2 s = input[input.size() - 1];

        ring.clear();

        for (vec2 e : input) {
            if (is_inside(e, p1, p2)) {
                if (!is_inside(s, p1, p2)) {
                    ring.push_back(intersection(p1, p2, s, e));
                }

                ring.push_back(e);
            } else if (is_inside(s, p1, p2)) {
                ring.push_back(intersection(p1, p2, s, e));
            }

            s = e;
        }

        p1 = p2;
    }

    return ring;
}

int main(int argc, char **argv) {
    // subject polygon
    vec2 subject_polygon[] = {{50, 150},  {200, 50},  {350, 150},
                              {350, 300}, {250, 300}, {200, 250},
                              {150, 350}, {100, 250}, {100, 200}};

    // clipping polygon
    vec2 clip_polygon[] = {{100, 100}, {300, 100}, {300, 300}, {100, 300}};

    // apply clipping
    std::vector<vec2> clipped_polygon =
        suther_land_hodgman(subject_polygon, clip_polygon);

    // print clipped polygon points
    std::cout << "Clipped polygon points:" << std::endl;
    for (vec2 p : clipped_polygon) {
        std::cout << "(" << p.x << ", " << p.y << ")" << std::endl;
    }

    return EXIT_SUCCESS;
}
