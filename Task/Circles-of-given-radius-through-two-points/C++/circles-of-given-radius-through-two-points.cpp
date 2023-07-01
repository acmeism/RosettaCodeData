#include <iostream>
#include <cmath>
#include <tuple>

struct point { double x, y; };

bool operator==(const point& lhs, const point& rhs)
{ return std::tie(lhs.x, lhs.y) == std::tie(rhs.x, rhs.y); }

enum result_category { NONE, ONE_COINCEDENT, ONE_DIAMETER, TWO, INFINITE };

using result_t = std::tuple<result_category, point, point>;

double distance(point l, point r)
{ return std::hypot(l.x - r.x, l.y - r.y); }

result_t find_circles(point p1, point p2, double r)
{
    point ans1 { 1/0., 1/0.}, ans2 { 1/0., 1/0.};
    if (p1 == p2) {
        if(r == 0.) return std::make_tuple(ONE_COINCEDENT, p1,   p2  );
        else        return std::make_tuple(INFINITE,       ans1, ans2);
    }
    point center { p1.x/2 + p2.x/2, p1.y/2 + p2.y/2};
    double half_distance = distance(center, p1);
    if(half_distance > r)      return std::make_tuple(NONE,         ans1,   ans2);
    if(half_distance - r == 0) return std::make_tuple(ONE_DIAMETER, center, ans2);
    double root = sqrt(pow(r, 2.l) - pow(half_distance, 2.l)) / distance(p1, p2);
    ans1.x = center.x + root * (p1.y - p2.y);
    ans1.y = center.y + root * (p2.x - p1.x);
    ans2.x = center.x - root * (p1.y - p2.y);
    ans2.y = center.y - root * (p2.x - p1.x);
    return std::make_tuple(TWO, ans1, ans2);
}

void print(result_t result, std::ostream& out = std::cout)
{
    point r1, r2; result_category res;
    std::tie(res, r1, r2) = result;
    switch(res) {
      case NONE:
        out << "There are no solutions, points are too far away\n"; break;
      case ONE_COINCEDENT: case ONE_DIAMETER:
        out << "Only one solution: " << r1.x << ' ' << r1.y << '\n'; break;
      case INFINITE:
        out << "Infinitely many circles can be drawn\n"; break;
      case TWO:
        out << "Two solutions: " << r1.x << ' ' << r1.y << " and " << r2.x << ' ' << r2.y << '\n'; break;
    }
}

int main()
{
    constexpr int size = 5;
    const point points[size*2] = {
        {0.1234, 0.9876}, {0.8765, 0.2345}, {0.0000, 2.0000}, {0.0000, 0.0000},
        {0.1234, 0.9876}, {0.1234, 0.9876}, {0.1234, 0.9876}, {0.8765, 0.2345},
        {0.1234, 0.9876}, {0.1234, 0.9876}
    };
    const double radius[size] = {2., 1., 2., .5, 0.};

    for(int i = 0; i < size; ++i)
        print(find_circles(points[i*2], points[i*2 + 1], radius[i]));
}
