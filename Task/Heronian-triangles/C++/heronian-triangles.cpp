#include <tuple>
#include <vector>
#include <numeric>
#include <iostream>
#include <algorithm>

#include <cmath>

struct Triangle {
    int a{};
    int b{};
    int c{};

    [[nodiscard]] constexpr auto perimeter() const noexcept { return a + b + c; }

    [[nodiscard]] constexpr auto area() const noexcept {
        const auto p_2 = static_cast<double>(perimeter()) / 2;
        const auto area_sq = p_2 * (p_2 - a) * (p_2 - b) * (p_2 - c);
        return std::sqrt(area_sq);
    }
};


auto generate_triangles(int side_limit = 200) {
    std::vector<Triangle> result;
    for(int a = 1; a <= side_limit; ++a)
        for(int b = 1; b <= a; ++b)
            for(int c = a + 1 - b; c <= b; ++c) // skip too-small values of c, which will violate triangle inequality
            {
                Triangle t{ a, b, c };
                const auto t_area = t.area();
                if (t_area == 0) continue;
                if (std::floor(t_area) == std::ceil(t_area) && std::gcd(a, std::gcd(b, c)) == 1)
                    result.push_back(t);
            }
    return result;
}

bool compare(const Triangle& lhs, const Triangle& rhs) noexcept {
    return std::make_tuple(lhs.area(), lhs.perimeter(), std::max(lhs.a, std::max(lhs.b, lhs.c))) <
           std::make_tuple(rhs.area(), rhs.perimeter(), std::max(rhs.a, std::max(rhs.b, rhs.c)));
}

struct area_compare {
    [[nodiscard]] constexpr bool operator()(const Triangle& t, int i) const noexcept { return t.area() < i; }
    [[nodiscard]] constexpr bool operator()(int i, const Triangle& t) const noexcept { return i < t.area(); }
};

int main() {
    auto tri = generate_triangles();
    std::cout << "There are " << tri.size() << " primitive Heronian triangles with sides up to 200\n\n";

    std::cout << "First ten when ordered by increasing area, then perimeter, then maximum sides:\n";
    std::sort(tri.begin(), tri.end(), compare);
    std::cout << "area\tperimeter\tsides\n";
    for(int i = 0; i < 10; ++i)
        std::cout << tri[i].area() << '\t' << tri[i].perimeter() << "\t\t" <<
                     tri[i].a << 'x' << tri[i].b << 'x' << tri[i].c << '\n';

    std::cout << "\nAll with area 210 subject to the previous ordering:\n";
    auto range = std::equal_range(tri.begin(), tri.end(), 210, area_compare());
    std::cout << "area\tperimeter\tsides\n";
    for(auto it = range.first; it != range.second; ++it)
        std::cout << (*it).area() << '\t' << (*it).perimeter() << "\t\t" <<
                     it->a << 'x' << it->b << 'x' << it->c << '\n';
}
