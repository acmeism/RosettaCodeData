#include <algorithm>
#include <cmath>
#include <iostream>
#include <tuple>
#include <vector>

int gcd(int a, int b)
{
    int rem = 1, dividend, divisor;
    std::tie(divisor, dividend) = std::minmax(a, b);
    while (rem != 0) {
        rem = dividend % divisor;
        if (rem != 0) {
            dividend = divisor;
            divisor = rem;
        }
    }
    return divisor;
}

struct Triangle
{
    int a;
    int b;
    int c;
};

int perimeter(const Triangle& triangle)
{
    return triangle.a + triangle.b + triangle.c;
}

double area(const Triangle& t)
{
    double p_2 = perimeter(t) / 2.;
    double area_sq = p_2 * ( p_2 - t.a ) * ( p_2 - t.b ) * ( p_2 - t.c );
    return sqrt(area_sq);
}

std::vector<Triangle> generate_triangles(int side_limit = 200)
{
    std::vector<Triangle> result;
    for(int a = 1; a <= side_limit; ++a)
        for(int b = 1; b <= a; ++b)
            for(int c = a+1-b; c <= b; ++c) // skip too-small values of c, which will violate triangle inequality
            {
                Triangle t{a, b, c};
                double t_area = area(t);
                if(t_area == 0) continue;
                if( std::floor(t_area) == std::ceil(t_area) && gcd(a, gcd(b, c)) == 1)
                    result.push_back(t);
            }
    return result;
}

bool compare(const Triangle& lhs, const Triangle& rhs)
{
    return std::make_tuple(area(lhs), perimeter(lhs), std::max(lhs.a, std::max(lhs.b, lhs.c))) <
           std::make_tuple(area(rhs), perimeter(rhs), std::max(rhs.a, std::max(rhs.b, rhs.c)));
}

struct area_compare
{
    bool operator()(const Triangle& t, int i) { return area(t) < i; }
    bool operator()(int i, const Triangle& t) { return i < area(t); }
};

int main()
{
    auto tri = generate_triangles();
    std::cout << "There are " << tri.size() << " primitive Heronian triangles with sides up to 200\n\n";

    std::cout << "First ten when ordered by increasing area, then perimeter, then maximum sides:\n";
    std::sort(tri.begin(), tri.end(), compare);
    std::cout << "area\tperimeter\tsides\n";
    for(int i = 0; i < 10; ++i)
        std::cout << area(tri[i]) << '\t' << perimeter(tri[i]) << "\t\t" <<
                     tri[i].a << 'x' << tri[i].b << 'x' << tri[i].c << '\n';

    std::cout << "\nAll with area 210 subject to the previous ordering:\n";
    auto range = std::equal_range(tri.begin(), tri.end(), 210, area_compare());
    std::cout << "area\tperimeter\tsides\n";
    for(auto it = range.first; it != range.second; ++it)
        std::cout << area(*it) << '\t' << perimeter(*it) << "\t\t" <<
                     it->a << 'x' << it->b << 'x' << it->c << '\n';
}
